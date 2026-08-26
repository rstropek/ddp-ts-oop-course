import { beforeEach, describe, expect, it } from 'vitest';
import { WaitingLine } from './waiting-line';

describe('WaitingLine', () => {
  let line: WaitingLine<string>;

  beforeEach(() => {
    line = new WaitingLine<string>();
  });

  describe('a fresh line', () => {
    it('is empty', () => {
      expect(line.isEmpty()).toBe(true);
    });

    it('has length 0', () => {
      expect(line.length).toBe(0);
    });

    it('has nobody in it', () => {
      expect(line.toArray()).toEqual([]);
    });

    it('gives back null on dequeue', () => {
      expect(line.dequeue()).toBeNull();
    });
  });

  describe('enqueue', () => {
    it('puts the first item at the front and at the back of the line', () => {
      // TODO: write this test.
      // The line is fresh. Add one item, then show that this one item is both
      // the front and the back of the line.
      expect.fail('Test not implemented yet');
    });

    it('makes the line non-empty', () => {
      // TODO: write this test.
      // The line is fresh. Add one item, then show that the line no longer
      // reports itself as empty.
      expect.fail('Test not implemented yet');
    });

    it('keeps the first item at the front while the newest joins the back', () => {
      // TODO: write this test.
      // Add three items, then show that they stand in the order they joined:
      // the first one at the front, the newest one at the back.
      expect.fail('Test not implemented yet');
    });

    it('grows the length with every item', () => {
      expect(line.length).toBe(0);

      line.enqueue('a');
      expect(line.length).toBe(1);

      line.enqueue('b');
      expect(line.length).toBe(2);
    });
  });

  describe('dequeue', () => {
    beforeEach(() => {
      line.enqueue('a');
      line.enqueue('b');
      line.enqueue('c');
    });

    it('hands out the items in the order they joined', () => {
      expect(line.dequeue()).toBe('a');
      expect(line.dequeue()).toBe('b');
      expect(line.dequeue()).toBe('c');
    });

    it('shrinks the length with every item it hands out', () => {
      expect(line.length).toBe(3);

      line.dequeue();
      expect(line.length).toBe(2);

      line.dequeue();
      expect(line.length).toBe(1);
    });

    it('moves the next item to the front', () => {
      line.dequeue();

      expect(line.toArray()).toEqual(['b', 'c']);
    });

    it('gives back null once the line is empty', () => {
      line.dequeue();
      line.dequeue();
      line.dequeue();

      expect(line.dequeue()).toBeNull();
    });

    it('leaves an empty line behind after the last item', () => {
      line.dequeue();
      line.dequeue();
      line.dequeue();

      expect(line.isEmpty()).toBe(true);
      expect(line.length).toBe(0);
      expect(line.toArray()).toEqual([]);
    });
  });

  describe('a line that was emptied', () => {
    it('takes new items again', () => {
      line.enqueue('a');
      line.dequeue();

      line.enqueue('b');
      line.enqueue('c');

      expect(line.isEmpty()).toBe(false);
      expect(line.toArray()).toEqual(['b', 'c']);
      expect(line.dequeue()).toBe('b');
    });

    it('takes an item that joins between two dequeues', () => {
      line.enqueue('a');
      line.enqueue('b');
      expect(line.dequeue()).toBe('a');

      line.enqueue('c');

      expect(line.dequeue()).toBe('b');
      expect(line.dequeue()).toBe('c');
      expect(line.dequeue()).toBeNull();
    });
  });

  describe('any type of item', () => {
    it('works with numbers', () => {
      const numbers = new WaitingLine<number>();
      numbers.enqueue(1);
      numbers.enqueue(2);

      expect(numbers.dequeue()).toBe(1);
      expect(numbers.toArray()).toEqual([2]);
    });
  });
});
