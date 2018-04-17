type classServer;

type classSocket;

class type socket =
  [@bs]
  {
    inherit NodeExtStream.duplexStream;
    pub classSocket: classSocket
  };

type address = {
  .
  "port": int,
  "family": string,
  "address": string,
};

class type server =
  [@bs]
  {
    pub classServer: classServer
  };

module Server: {
  [@bs.send] external address : Js.t(#server) => address = "";
  [@bs.send]
  external close :
    (Js.t(#server), ~callback: unit => unit, unit) => Js.t(server) =
    "";
  [@bs.send]
  external getConnections :
    (Js.t(#server), (Js.undefined(Js.Exn.t), int) => unit) => unit =
    "";
  [@bs.send] external listen : Js.t(#server) => unit = "";
  [@bs.send]
  external listenTCP :
    (
      Js.t(#server),
      ~port: int,
      ~host: string=?,
      ~callback: unit => unit=?,
      unit
    ) =>
    unit =
    "listen";
  [@bs.send]
  external listenUnix :
    (
      Js.t(#server),
      ~path: string,
      ~backlog: int=?,
      ~callback: unit => unit=?,
      unit
    ) =>
    unit =
    "listen";
  [@bs.send] external getListening : Js.t(#server) => bool = "listening";
  [@bs.send]
  external getMaxConnections : Js.t(#server) => int = "maxConnections";
  [@bs.send] external ref : Js.t(#server) => Js.t(#server) = "";
  external unref : Js.t(#server) => Js.t(#server) = "";
  [@bs.send.pipe: Js.t(#server)]
  external on :
    (
    [@bs.string]
    [
      | `close(unit => unit)
      | `connection(socket => unit)
      | `error(Js.Exn.t => unit)
      | `listening(unit => unit)
    ]
    ) =>
    Js.t(#server) =
    "";
};

/**
 * TODO: Finish socket bindings.
 */
module Socket: {
  include (module type of NodeExtStream.ReadableStream);
  include (module type of NodeExtStream.WritableStream);
  [@bs.send] external address : Js.t(#socket) => address = "";
  [@bs.send.pipe: Js.t(#socket)]
  external on :
    (
    [@bs.string]
    [
      | `close(unit => unit)
      | `connect(unit => unit)
      | `lookup(
          (
            Js.undefined(Js.Exn.t),
            Js.undefined(string),
            Js.undefined(string),
            Js.undefined(string)
          ) =>
          unit,
        )
      | `timeout(unit => unit)
    ]
    ) =>
    Js.t(#server) =
    "";
};