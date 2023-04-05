import { useSocket } from "$lib/context/socket";
import { derived, get, type Readable, type Writable } from "svelte/store";
import type { StoreChannel, StoreSocket } from "./socket";

export function model<T extends object>(topic: string): Writable<T | undefined>;
export function model<T extends object>(topic: string, defaultValue: T): Writable<T>;
export function model<T extends object>(topic: string, defaultValue?: T) {
  const socket = useSocket();
  const channel = derived<Readable<StoreSocket>, StoreChannel>(socket, (socket, set) => {
    return socket.channel(topic).subscribe(set);
  });

  const { subscribe } = derived<Readable<StoreChannel>, T | undefined>(channel, (channel, set) =>
    channel.on<T | undefined>("update", defaultValue).subscribe(set),
  );

  function set(value: T) {
    get(channel).push("update", value);
  }

  return { subscribe, set };
}
