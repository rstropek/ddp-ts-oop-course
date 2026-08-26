import './styles.css';
import type { PartKind } from './train-part';

type PartOption = {
  kind: PartKind;
  label: string;
};

/** One button per entry, in this order. */
const PART_OPTIONS: PartOption[] = [
  { kind: 'locomotive', label: 'Locomotive (2400 kW)' },
  { kind: 'passenger', label: 'Passenger wagon (48 seats)' },
  { kind: 'cargo', label: 'Cargo wagon (70 t)' },
  { kind: 'dining', label: 'Dining wagon (8 tables)' },
  { kind: 'caboose', label: 'Caboose (2 crew)' },
];

const trainElement = document.querySelector<HTMLDivElement>('#train');
const messageElement = document.querySelector<HTMLParagraphElement>('#message');
const buttonRow = document.querySelector<HTMLParagraphElement>('#partButtons');
const removeButton = document.querySelector<HTMLButtonElement>('#removeButton');

if (!trainElement || !messageElement || !buttonRow || !removeButton) {
  throw new Error('The page is missing an element the app needs.');
}

// TODO: build the train here, once the Train class exists.

// TODO: write showMessage(message: string | null), which puts the text into
// messageElement and clears it again for null.

// TODO: write render(), which redraws trainElement from the train and
// disables removeButton while the train is empty.

for (const option of PART_OPTIONS) {
  const button = document.createElement('button');
  button.type = 'button';
  button.textContent = option.label;
  button.addEventListener('click', () => {
    // TODO: build the part for option.kind, offer it to the train, show the
    // message that comes back, and redraw.
    console.log(option.kind);
  });
  buttonRow.append(button);
}

removeButton.addEventListener('click', () => {
  // TODO: take the newest part off the train, clear the message, and redraw.
  console.log('remove last');
});

// TODO: call render() once here, so the fresh page shows its empty state.
