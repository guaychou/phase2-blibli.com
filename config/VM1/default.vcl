vcl 4.0;
import directors;
# Default backend definition. Set this to point to your content server.
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
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
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
