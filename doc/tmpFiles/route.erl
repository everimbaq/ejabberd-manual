route


do_route/3
路由到1.[] ,即本地不存在该路由，发给s2s
	2.[R] 存在唯一路由 发给ejabberd_local
	3.Rs  domain_balancing  从多个route中根据


do_route(OrigFrom, OrigTo, OrigPacket) ->
    case ejabberd_hooks:run_fold(filter_packet, {OrigFrom, OrigTo, OrigPacket}, []) of
      {From, To, Packet} ->
		  LDstDomain = To#jid.lserver,
		  case mnesia:dirty_read(route, LDstDomain) of
			    [] -> ejabberd_s2s:route(From, To, Packet);
			    [R] ->
					Pid = R#route.pid,
					if node(Pid) == node() ->
					       case R#route.local_hint of
							 {apply, Module, Function} ->
							     	Module:Function(From, To, Packet);
							 _ -> 
							 		Pid ! {route, From, To, Packet}
					       end;
					   is_pid(Pid) -> 
					   		Pid ! {route, From, To, Packet};
					   true -> 
					   		drop
					end;
	    		Rs ->
					Value = case
						  ejabberd_config:get_local_option({domain_balancing, LDstDomain}, fun(D) when is_atom(D) -> D end)
						    of
							  undefined -> now();
							  random -> now();
							  source -> jlib:jid_tolower(From);
							  destination -> jlib:jid_tolower(To);
							  bare_source ->
							      jlib:jid_remove_resource(jlib:jid_tolower(From));
							  bare_destination ->
							      jlib:jid_remove_resource(jlib:jid_tolower(To))
						end,
					case get_component_number(LDstDomain) of
					  undefined ->
					      case [R || R <- Rs, node(R#route.pid) == node()] of
								[] ->
								    R = lists:nth(erlang:phash(Value, length(Rs)), Rs),
								    Pid = R#route.pid,
								    if is_pid(Pid) -> 
								    		Pid ! {route, From, To, Packet};
								       true -> 
								       		drop
								    end;
								LRs ->
								    R = lists:nth(erlang:phash(Value, length(LRs)),
										  LRs),
								    Pid = R#route.pid,
								    case R#route.local_hint of
								      {apply, Module, Function} ->
									  		Module:Function(From, To, Packet);
								      _ -> 
								      		Pid ! {route, From, To, Packet}
								    end						  
						  end;
					  	_ ->
					      SRs = lists:ukeysort(#route.local_hint, Rs),
					      R = lists:nth(erlang:phash(Value, length(SRs)), SRs),
					      Pid = R#route.pid,
					      if 
					      	is_pid(Pid) -> Pid ! {route, From, To, Packet};
						 	true -> drop
					      end
				end
		  end;
      drop -> ok
    end.




register_route(Domain, LocalHint) ->
    case jlib:nameprep(Domain) of
      error -> erlang:error({invalid_domain, Domain});
      LDomain ->
	  	Pid = self(), 
	  	case get_component_number(LDomain) of
	    	undefined ->
				F = fun () ->				
					    mnesia:write(#route{domain = LDomain, pid = Pid,
								local_hint = LocalHint})
				    end,
				mnesia:transaction(F);
	    	N ->
				F = fun () ->
					    case mnesia:wread({route, LDomain}) of
					      [] ->
							  mnesia:write(#route{domain = LDomain, pid = Pid, local_hint = 1}),
							  lists:foreach(fun (I) ->
										mnesia:write(#route{domain = LDomain, pid = undefined, local_hint = I})
									end, lists:seq(2, N));
					      Rs ->
							  lists:any(fun 
							  				(#route{pid = undefined, local_hint = I} = R) ->
											    mnesia:write(#route{domain =  LDomain, pid = Pid, local_hint = I}),
											    mnesia:delete_object(R),
											    true;
											(_) -> 
												false
										end, Rs)
					    end
				    end,
				mnesia:transaction(F)
	  end
    end.