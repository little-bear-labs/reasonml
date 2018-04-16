type dataOut;

/*
 Ensure each class is structrually different.
 */
type writableStreamClass;

class type writableStream =
  [@bs]
  {
    pub classWritableStream: writableStreamClass
  };

/*
 Ensure each class is structrually different.
 */
type readableStreamClass;

class type readableStream =
  [@bs]
  {
    pub classReadableStream: readableStreamClass
  };

type duplexStreamClass;

class type duplexStream =
  [@bs]
  {
    inherit readableStream;
    inherit writableStream;
    pub classDuplexStream: duplexStreamClass
  };

type transformStreamClass;

class type transformStream =
  [@bs]
  {
    inherit duplexStream;
    pub classTransformStream: transformStreamClass
  };

type passThroughClass;

class type passThroughStream =
  [@bs]
  {
    inherit transformStream;
    pub classPassThroughStream: passThroughClass
  };

module ReadableStream: {
  [@bs.send] external isPaused : Js.t(#readableStream) => bool = "";
  [@bs.send.pipe: Js.t(#readableStream)]
  external pause : unit => Js.t(#readableStream) = "";
  [@bs.send]
  external pipe :
    (Js.t(#readableStream), Js.t(#writableStream)) => Js.t(#readableStream) =
    "";
  [@bs.get]
  external getReadableHighWaterMark : Js.t(#readableStream) => int =
    "readableHighWaterMark";
  [@bs.set]
  external setReadableHighWaterMark : (Js.t(#readableStream), int) => int =
    "readableHighWaterMark";
  [@bs.send] external read : (Js.t(#readableStream), int) => dataOut = "";
  [@bs.get]
  external getReadableLength : Js.t(#readableStream) => int =
    "readableLength";
  [@bs.send.pipe: Js.t(#readableStream)]
  external resume : unit => Js.t(#readableStream) = "";
  [@bs.send] external setEncoding : string => Js.t(#readableStream) = "";
  [@bs.send]
  external unpipe :
    (Js.t(#readableStream), Js.t(#writableStream), unit) =>
    Js.t(readableStream) =
    "";
  [@bs.send] external unpipeAll : Js.t(#readableStream) => unit = "unpipe";
  [@bs.send.pipe: Js.t(#readableStream)]
  external on :
    (
    [@bs.string]
    [
      | `close(unit => 'a)
      | `data(dataOut => 'a)
      | `error(Js.Exn.t => unit)
      | `readable(unit => unit)
    ]
    ) =>
    Js.t(#readableStream) =
    "";
  [@bs.send.pipe: Js.t(#readableStream)]
  external onEnd : ([@bs.as "end"] _, unit => unit) => 'a = "on";
};

module WritableStream: {
  [@bs.send] external cork : Js.t(#writableStream) => unit = "";
  [@bs.send] external endStream : Js.t(#writableStream) => unit = "end";
  [@bs.send] external uncork : Js.t(#writableStream) => unit = "";
  [@bs.get]
  external getWritableHighWaterMark : Js.t(#writableStream) => int =
    "writableHighWaterMark";
  [@bs.get]
  external getWritableLength : Js.t(#writableStream) => int =
    "writableLength";
  [@bs.send]
  external writeString :
    (
      Js.t(#writableStream),
      ~data: string,
      ~encoding: [@bs.string] [
                   | [@bs.as "ascii"] `ascii
                   | [@bs.as "base64"] `base64
                   | [@bs.as "binary"] `binary
                   | [@bs.as "hex"] `hex
                   | [@bs.as "ucs2"] `ucs2
                   | [@bs.as "utf16le"] `utf16le
                   | [@bs.as "utf8"] `utf8
                   | [@bs.as "latin1"] `latin1
                 ]
                   =?,
      unit
    ) =>
    bool =
    "write";
  [@bs.send]
  external writeBuffer :
    (
      Js.t(#writableStream),
      ~data: BsNode.NodeBuffer.t,
      ~encoding: [@bs.string] [
                   | [@bs.as "ascii"] `ascii
                   | [@bs.as "base64"] `base64
                   | [@bs.as "binary"] `binary
                   | [@bs.as "hex"] `hex
                   | [@bs.as "ucs2"] `ucs2
                   | [@bs.as "utf16le"] `utf16le
                   | [@bs.as "utf8"] `utf8
                   | [@bs.as "latin1"] `latin1
                 ]
                   =?,
      unit
    ) =>
    bool =
    "write";
  external destroy : (Js.t(#writableStream), Js.Exn.t) => unit = "";
  [@bs.send.pipe: Js.t(#writableStream)]
  external on :
    (
    [@bs.string]
    [
      | `close(unit => unit)
      | `drain(unit => unit)
      | `finish(unit => unit)
      | `pipe(Js.t(#readableStream) => unit)
      | `unpipe(Js.t(#readableStream) => unit)
    ]
    ) =>
    Js.t(#writableStream) =
    "";
  [@bs.send.pipe: Js.t(#writableStream)]
  external onEnd : ([@bs.as "end"] _, unit => unit) => 'a = "on";
};

[@bs.new] [@bs.module "stream"]
external createPassThroughStream : unit => Js.t(passThroughStream) =
  "PassThrough";