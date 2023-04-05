import { readable, type Readable } from "svelte/store";
import { browser } from "$app/environment";
import { Socket, type SocketConnectOption } from "phoenix";

type StoreChannel = {
  on<T>(this: void, event: string): Readable<T | undefined>;
  on<T>(this: void, event: string, defaultValue: T): Readable<T>;
  push(this: void, event: string, payload: object, timeout?: number): void;
};

type StoreSocket = {
  channel(this: void, topic: string, params: object): Readable<StoreChannel>;
};

export function socket(url: string, opts: Partial<SocketConnectOption>): Readable<StoreSocket> {
  if (!browser) {
    return readable({
      channel: (_topic: string, _params: object) =>
        readable({
          on: <T>(_event: string, defaultValue?: T) => readable(defaultValue),
          push: (_event: string, _payload: object, _timeout?: number) => {},
        }),
    });
  }

  const socket = new Socket(url, opts);

  function channel(topic: string, params: object) {
    const channel = socket.channel(topic, params);

    function on<T>(event: string): Readable<T | undefined>;
    function on<T>(event: string, defaultValue: T): Readable<T>;
    function on<T>(event: string, defaultValue?: T): Readable<T | undefined> {
      return readable(defaultValue, (set) => {
        const handler = channel.on(event, set);
        return () => channel.off(event, handler);
      });
    }

    function push(event: string, payload: object, timeout?: number) {
      channel.push(event, payload, timeout);
    }

    return readable<StoreChannel>({ on, push }, () => {
      channel.join();
      return () => channel.leave();
    });
  }

  return readable<StoreSocket>({ channel }, () => {
    console.log(`Connecting to socket: ${url}`);
    socket.connect();
    socket.onOpen(() => console.log("Connection opened"));
    socket.onError((error) => console.error("Socket error", error));
    socket.onClose(() => console.log("Connection closed"));
    return () => socket.disconnect();
  });
}
