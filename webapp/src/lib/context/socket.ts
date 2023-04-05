import { getContext, setContext } from "svelte";
import { socket, type StoreSocket } from "$lib/store/socket";
import type { SocketConnectOption } from "phoenix";
import type { Readable } from "svelte/store";

const SOCKET = Symbol("SOCKET");

export function createSocket(url: string, opts: Partial<SocketConnectOption>) {
  setContext(SOCKET, socket(url, opts));
}

export function useSocket(): Readable<StoreSocket> {
  return getContext(SOCKET);
}
