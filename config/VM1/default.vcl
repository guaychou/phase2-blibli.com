vcl 4.0;
import directors;

acl purger {
    "localhost";
    "server1.ku";

}

backend server2 {
    .host = "server2.ku";
    .port = "80";
}

backend server3 {
    .host = "server3.ku";
    .port = "80";
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.
  
    if (req.method == "PURGE") {
	if (!client.ip ~ purger) {
	    return(synth(405, "Your IP cannot use purge method ."));
        }
    return (purge);
   }

   if (req.url ~ "wp-admin|wp-login") {
   return (pass);
   }
   

}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
    
    set beresp.ttl = 24h;
    set beresp.grace = 1h;
    
    if (bereq.url !~ "backend|wp-admin|wp-login|product|cart|checkout|my-account|/?remove_item=") {
        unset beresp.http.set-cookie;
         } 
        
    if ( beresp.status == 404 ) {
        set beresp.ttl = 0s;
    }
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}

sub vcl_init {
    new bar = directors.round_robin();
    bar.add_backend(server2);
    bar.add_backend(server3);
}
sub vcl_recv {
    # send all traffic to the bar director:
    set req.backend_hint = bar.backend();
}
