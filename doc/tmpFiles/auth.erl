015-06-11 17:21:26.245 [info] <0.2556.0>@ejabberd_listener:accept:309 (#Port<0.14742>) Accepted connection 192.168.8.110:16060 -> 192.168.8.138:5222
Received XML on stream = <<"<stream:stream xmlns:stream=\"http://etherx.jabber.org/streams\" xmlns=\"jabber:client\" to=\"innodealing-dev\" version=\"1.0\" >">>
Send XML on stream = <<"<?xml version='1.0'?><stream:stream xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/streams' id='3862861623' from='innodealing-dev' version='1.0' xml:lang='en'>">>
Send XML on stream = <<"<stream:features><mechanisms xmlns='urn:ietf:params:xml:ns:xmpp-sasl'><mechanism>PLAIN</mechanism><mechanism>DIGEST-MD5</mechanism><mechanism>SCRAM-SHA-1</mechanism></mechanisms><c xmlns='http://jabber.org/protocol/caps' hash='sha-1' node='http://www.process-one.net/en/ejabberd/' ver='mesHYJTB7F8NqNdb/KcURpMub2M='/><register xmlns='http://jabber.org/features/iq-register'/></stream:features>">>
Received XML on stream = <<"<auth mechanism=\"SCRAM-SHA-1\" xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\">biwsbj10ZXN0MSxyPURZazkzRzBFSUdiTTFnQVBlTDZ6WThQM2t0NDhaTVVn</auth>">>
Send XML on stream = <<"<challenge xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>cj1EWWs5M0cwRUlHYk0xZ0FQZUw2elk4UDNrdDQ4Wk1VZ0hoekRLK0JxZFdVUW5zdDgvdFBrT1E9PSxzPWgwQW9xYmJnMmRvUHBHeWtwUU5jeUE9PSxpPTQwOTY=</challenge>">>
Received XML on stream = <<"<response xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\">Yz1iaXdzLHI9RFlrOTNHMEVJR2JNMWdBUGVMNnpZOFAza3Q0OFpNVWdIaHpESytCcWRXVVFuc3Q4L3RQa09RPT0scD1pOUZPd1FSVUYwbTM1Yys1MDNjUXVOWXUvOE09</response>">>

ejabberd_c2s:wait_for_sasl_response:936 ({socket_state,gen_tcp,#Port<0.14742>,<0.3319.0>}) Accepted authentication for test1 by undefined from 192.168.8.110
Send XML on stream = <<"<success xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>dj1OZW5yOW5jQldSTHl3NmdWQnBDaWNXZmttVHc9</success>">>
Received XML on stream = <<"<stream:stream xmlns:stream=\"http://etherx.jabber.org/streams\" xmlns=\"jabber:client\" to=\"innodealing-dev\" version=\"1.0\" >">>

Send XML on stream = <<"<?xml version='1.0'?><stream:stream xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/streams' id='2740094463' from='innodealing-dev' version='1.0' xml:lang='en'>">>
Send XML on stream = <<"<stream:features><bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'/><session xmlns='urn:ietf:params:xml:ns:xmpp-session'/><sm xmlns='urn:xmpp:sm:2'/><sm xmlns='urn:xmpp:sm:3'/><csi xmlns='urn:xmpp:csi:0'/><c xmlns='http://jabber.org/protocol/caps' hash='sha-1' node='http://www.process-one.net/en/ejabberd/' ver='mesHYJTB7F8NqNdb/KcURpMub2M='/><register xmlns='http://jabber.org/features/iq-register'/></stream:features>">>

Received XML on stream = <<"<iq id=\"MX_1\" type=\"set\"><bind xmlns=\"urn:ietf:params:xml:ns:xmpp-bind\"><resource>DM</resource></bind></iq>">>
Send XML on stream = <<"<iq id='MX_1' type='result'><bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'><jid>test1@innodealing-dev/DM</jid></bind></iq>">>
Received XML on stream = <<"<iq id=\"MX_2\" type=\"set\"><session xmlns=\"urn:ietf:params:xml:ns:xmpp-session\" /></iq>">>

ejabberd_c2s:wait_for_session:1124 ({socket_state,gen_tcp,#Port<0.14742>,<0.3319.0>}) Opened session for test1@innodealing-dev/DM
Send XML on stream = <<"<iq type='result' id='MX_2'/>">>
Received XML on stream = <<"<iq id=\"MX_3\" type=\"get\"><query xmlns=\"jabber:iq:roster\" /></iq>">>
	Received iq time
	Received iq auth
	*****Any IQ ****
	<presence>
