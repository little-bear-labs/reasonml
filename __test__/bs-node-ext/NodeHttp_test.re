open Jest;

open NodeExtHttp;

describe("http", () => {
  open ExpectJs;
  open! Expect.Operators;
  testAsync("toy server + request", finish => {
    let server =
      createServer((req, res) => {
        open IncomingMessage;
        open ServerResponse;
        res |. setHeader("test-method", getMethod(req)) |> ignore;
        setHeader(res, "test-url", getUrl(req)) |> ignore;
        writeHead(res, ~status=200, ());
        endStream(res);
        ();
      });
    let makeRequest = () => {
      let addr: NodeExtNet.address = Server.address(server);
      let url = "http://localhost:" ++ string_of_int(addr##port) ++ "/test";
      let _ =
        getUrl(
          url,
          res => {
            let headers = IncomingMessage.getHeaders(res);
            switch (Js.Dict.get(headers, "test-method")) {
            | Some(str) => expect(str) |> toBe("GET") |> ignore
            | _ => Js.Exn.raiseError("No test-method")
            };
            switch (Js.Dict.get(headers, "test-url")) {
            | Some(str) => expect(str) |> toBe("/test") |> ignore
            | _ => Js.Exn.raiseError("No test-url")
            };
            finish(expect(1) |> toBe(1));
            ();
          },
        );
      ();
    };
    server |> NodeExtNet.Server.on(`listening(() => makeRequest())) |> ignore;
    server |. Server.listenWithPort(0) |> ignore;
  });
});