open BsNode;

type socket = NodeExtNet.socket;

type classClientRequest;

class type clientRequest =
  [@bs]
  {
    inherit NodeExtStream.writableStream;
    pub classClientRequest: classClientRequest
  };

type classServer;

class type server = {
  inherit NodeExtNet.server;
  pub httpClassServer: classServer
};

/* TODO: inherit from net server */
type classServerResponse;

class type serverResponse =
  [@bs]
  {
    inherit NodeExtStream.writableStream;
    pub classServerResponse: classServerResponse
  };

type classIncomingMessage;

class type incomingMessage =
  [@bs]
  {
    inherit NodeExtStream.readableStream;
    pub classIncomingMessage: classIncomingMessage
  };

module ClientRequest: {
  /* placeholder type */
  [@bs.send] external abort : Js.t(#clientRequest) => unit = "";
  [@bs.get]
  external getConnection : Js.t(#clientRequest) => socket = "connection";
  [@bs.send] external flushHeaders : Js.t(#clientRequest) => unit = "";
  [@bs.send]
  external getHeader : (Js.t(#clientRequest), string) => string = "";
  [@bs.send]
  external removeHeader : (Js.t(#clientRequest), string) => unit = "";
  external setHeader : (Js.t(#clientRequest), string, string) => unit = "";
  [@bs.send] external setNoDelay : (Js.t(#clientRequest), bool) => unit = "";
  [@bs.send.pipe: Js.t(#clientRequest)]
  external setTimeout : (Js.t(#clientRequest), int) => Js.t(#clientRequest) =
    "";
  external setTimeoutCb :
    (Js.t(#clientRequest), int, unit => unit) => Js.t(#clientRequest) =
    "setTimeout";
  [@bs.send.pipe: Js.t(#clientRequest)]
  external on :
    (
    [@bs.string]
    [
      | `abort(unit => unit)
      | `connect((Js.t(incomingMessage), socket, NodeBuffer.t) => unit)
      | `continue(unit => unit)
      | `response(Js.t(incomingMessage) => unit)
      | `socket(socket => unit)
      | `upgrade((Js.t(incomingMessage), socket, NodeBuffer.t) => unit)
    ]
    ) =>
    Js.t(#clientRequest) =
    "";
};

module Server: {
  include (module type of NodeExtNet.Server);
  [@bs.send] external close : Js.t(#server) => unit = "";
  [@bs.send] external closeCb : (unit => unit) => unit = "close";
  [@bs.send] external listen : Js.t(#server) => unit = "";
  [@bs.get] external getListening : Js.t(#server) => bool = "listening";
  [@bs.get]
  external getMaxHeadersCount : Js.t(#server) => int = "maxHeadersCount";
  [@bs.send]
  external setTimeout : (Js.t(#server), int) => Js.t(#clientRequest) = "";
  external setTimeoutCb :
    (Js.t(#server), int, unit => unit) => Js.t(#clientRequest) =
    "setTimeout";
  [@bs.get] external getTimeout : Js.t(#server) => int = "timeout";
  [@bs.get]
  external getKeepAliveTimeout : Js.t(#server) => int = "keepAliveTimeout";
  [@bs.set]
  external setKeepAliveTimeout : (Js.t(#server), int) => int =
    "keepAliveTimeout";
  [@bs.send.pipe: Js.t(server)]
  external on :
    (
    [@bs.string]
    [
      | `checkContinue(
          (Js.t(incomingMessage), Js.t(serverResponse)) => unit,
        )
      | `checkException(
          (Js.t(incomingMessage), Js.t(serverResponse)) => unit,
        )
      | `clientError((Js.Exn.t, socket) => unit)
      | `close(unit => unit)
      | `connection(socket => unit)
      | `request((Js.t(incomingMessage), Js.t(serverResponse)) => unit)
      | `upgrade((Js.t(incomingMessage), socket, NodeBuffer.t) => unit)
    ]
    ) =>
    Js.t(server) =
    "";
};

module ServerResponse: {
  include (module type of NodeExtStream.WritableStream);
  [@bs.send]
  external addTrailers : (Js.t(#serverResponse), Js.Dict.t(string)) => unit =
    "";
  [@bs.get]
  external getConnection : Js.t(#serverResponse) => socket = "connection";
  [@bs.get] external getFinished : Js.t(#serverResponse) => bool = "finished";
  [@bs.send]
  external getHeader : (Js.t(#serverResponse), string) => unit = "";
  [@bs.send]
  external getHeaderNames : Js.t(#serverResponse) => array(string) = "";
  [@bs.send]
  external getHeaders : Js.t(#serverResponse) => Js.Dict.t(string) = "";
  [@bs.send] external hasHeader : Js.t(#serverResponse) => bool = "";
  [@bs.get]
  external getHeadersSent : Js.t(#serverResponse) => bool = "headersSent";
  [@bs.send]
  external removeHeader : (Js.t(#serverResponse), string) => bool = "";
  [@bs.set]
  external setSendDate : (Js.t(#serverResponse), bool) => bool = "sendDate";
  [@bs.send]
  external setHeader : (Js.t(#serverResponse), string, string) => bool = "";
  external setTimeout : (Js.t(#serverResponse), int) => Js.t(#clientRequest) =
    "";
  external setTimeoutCb :
    (Js.t(#serverResponse), int, unit => unit) => Js.t(#clientRequest) =
    "setTimeout";
  [@bs.get] external getSocket : Js.t(#serverResponse) => socket = "socket";
  [@bs.get]
  external getStatusCode : Js.t(#serverResponse) => int = "statusCode";
  [@bs.set]
  external setStatusCode : (Js.t(#serverResponse), int) => int = "statusCode";
  [@bs.get]
  external getStatusMessage : Js.t(#serverResponse) => string =
    "statusMessage";
  [@bs.set]
  external setStatusMessage : (Js.t(#serverResponse), string) => string =
    "statusMessage";
  [@bs.send] external writeContinue : Js.t(#serverResponse) => unit = "";
  [@bs.send]
  external writeHead :
    (
      Js.t(#serverResponse),
      ~status: int,
      ~message: string=?,
      ~headers: Js.Dict.t(string)=?,
      unit
    ) =>
    unit =
    "";
  [@bs.send.pipe: Js.t(#serverResponse)]
  external on :
    ([@bs.string] [ | `close(unit => unit) | `finish(unit => unit)]) =>
    Js.t(#serverResponse) =
    "";
};

module IncomingMessage: {
  [@bs.send] external destroy : Js.t(#incomingMessage) => unit = "";
  [@bs.send]
  external destroyWithError : (Js.t(#incomingMessage), Js.Exn.t) => unit = "";
  [@bs.get]
  external getHeaders : Js.t(#incomingMessage) => Js.Dict.t(string) =
    "headers";
  [@bs.get]
  external getHttpVersion : Js.t(#incomingMessage) => string = "httpVersion";
  [@bs.get] external getMethod : Js.t(#incomingMessage) => string = "method";
  [@bs.get]
  external getRawHeader : Js.t(#incomingMessage) => array(string) =
    "rawHeaders";
  [@bs.get]
  external getRawTrailers : Js.t(#incomingMessage) => array(string) =
    "rawTrailers";
  [@bs.get] external getSocket : Js.t(#incomingMessage) => socket = "socket";
  [@bs.get]
  external getStatusCode : Js.t(#incomingMessage) => socket = "statusCode";
  [@bs.get]
  external getStatusMessage : Js.t(#incomingMessage) => socket =
    "statusMessage";
  [@bs.get]
  external getTrailers : Js.t(#incomingMessage) => socket = "trailers";
  [@bs.get] external getUrl : Js.t(#incomingMessage) => string = "url";
  [@bs.send.pipe: Js.t(#incomingMessage)]
  external on :
    ([@bs.string] [ | `aborted(unit => unit) | `close(unit => unit)]) =>
    Js.t(#incomingMessage) =
    "";
};

[@bs.module "http"]
external createServer :
  ((Js.t(incomingMessage), Js.t(serverResponse)) => unit) => Js.t(server) =
  "createServer";

[@bs.module "http"]
external getUrl :
  (string, Js.t(incomingMessage) => unit) => Js.t(clientRequest) =
  "get";

module HttpRequestOpts: {
  [@bs.deriving abstract]
  type t = {
    [@bs.optional]
    protocol: string,
    [@bs.optional]
    host: string,
    [@bs.optional]
    hostname: string,
    [@bs.optional]
    family: int,
    [@bs.optional]
    port: int,
    [@bs.optional]
    localAddress: string,
    [@bs.optional]
    socketPath: string,
    [@bs.optional] [@bs.as "method"]
    httpMethod: string,
    [@bs.optional]
    path: string,
    [@bs.optional]
    headers: Js.Dict.t(string),
    [@bs.optional]
    auth: string,
    [@bs.optional]
    timeout: int,
    [@bs.optional]
    setHost: bool,
  };
};

external getWithOptions :
  (HttpRequestOpts.t, ~callback: Js.t(incomingMessage) => unit=?, unit) =>
  Js.t(clientRequest) =
  "get";

external request :
  (HttpRequestOpts.t, ~callback: Js.t(incomingMessage) => unit=?, unit) =>
  Js.t(clientRequest) =
  "";