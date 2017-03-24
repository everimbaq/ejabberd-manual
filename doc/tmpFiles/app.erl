start(normal, _Args) ->
    ejabberd_logger:start(),  
    write_pid_file(), 
    start_apps(), 
    ejabberd:check_app(ejabberd),
    randoms:start(),
    db_init(),
    start(),
    translate:start(),
    ejabberd_ctl:init(),
    ejabberd_commands:init(),
    ejabberd_admin:start(),
    gen_mod:start(),
    ejabberd_config:start(),
    set_loglevel_from_config(),
    acl:start(),
    shaper:start(),
    connect_nodes(),
    Sup = ejabberd_sup:start_link(),
    ejabberd_rdbms:start(),
    ejabberd_riak_sup:start(),
    ejabberd_auth:start(),
    cyrsasl:start(),
    % Profiling
    %ejabberd_debug:eprof_start(),
    %ejabberd_debug:fprof_start(),
    maybe_add_nameservers(),
    start_modules(),
    ejabberd_listener:start_listeners(),
    ?INFO_MSG("ejabberd ~s is started in the node ~p", [?VERSION, node()]),
    Sup.



ejabberd_config:get_option