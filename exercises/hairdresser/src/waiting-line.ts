// One place in the line: a customer, and a pointer to whoever stands behind them.
class Node<T> {
  value: T;
  next: Node<T> | null = null;

  constructor(value: T) {
    this.value = value;
  }
}

export class WaitingLine<T> {
  // The front of the line: the customer who is served next.
  private head: Node<T> | null = null;
  // The back of the line: the customer who joined last.
  private tail: Node<T> | null = null;

  // TODO: write the five members below.
  // Watch the two edge cases: the first enqueue has to set head and tail, and
  // the dequeue that hands out the last item has to clear both again.

  enqueue(item: T): void {
    throw new Error('Method not implemented.');
  }

  dequeue(): T | null {
    throw new Error('Method not implemented.');
  }

  get length(): number {
    throw new Error('Method not implemented.');
  }

  isEmpty(): boolean {
    throw new Error('Method not implemented.');
  }

  toArray(): T[] {
    throw new Error('Method not implemented.');
  }
}
