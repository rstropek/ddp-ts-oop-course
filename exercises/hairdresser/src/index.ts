import './styles.css';
import type { Customer } from './customer';
import { WaitingLine } from './waiting-line';

const line = new WaitingLine<Customer>();

const humanFirstName = document.querySelector<HTMLInputElement>('#humanFirstName');
const humanLastName = document.querySelector<HTMLInputElement>('#humanLastName');
const humanLongHair = document.querySelector<HTMLInputElement>('#humanLongHair');
const addHumanButton = document.querySelector<HTMLButtonElement>('#addHumanButton');
const dogName = document.querySelector<HTMLInputElement>('#dogName');
const dogBreed = document.querySelector<HTMLInputElement>('#dogBreed');
const addDogButton = document.querySelector<HTMLButtonElement>('#addDogButton');
const serveButton = document.querySelector<HTMLButtonElement>('#serveButton');
const lineDisplay = document.querySelector<HTMLDivElement>('#line');
const countLine = document.querySelector<HTMLParagraphElement>('#countLine');
const message = document.querySelector<HTMLParagraphElement>('#message');

if (
  !humanFirstName ||
  !humanLastName ||
  !humanLongHair ||
  !addHumanButton ||
  !dogName ||
  !dogBreed ||
  !addDogButton ||
  !serveButton ||
  !lineDisplay ||
  !countLine ||
  !message
) {
  throw new Error('The page is missing an element');
}

const render = (): void => {
  const customers = line.toArray();
  const nowServing = customers[0];
  const nextUp = customers[1];

  lineDisplay.replaceChildren();

  if (!nowServing) {
    const empty = document.createElement('p');
    empty.className = 'empty';
    empty.textContent = 'The line is empty.';
    lineDisplay.append(empty);
  } else {
    const serving = document.createElement('p');
    serving.className = 'now-serving';
    // TODO: let the customer at the front describe itself.
    serving.textContent = 'Now serving: TODO';
    lineDisplay.append(serving);

    if (nextUp) {
      const next = document.createElement('p');
      next.className = 'next-up';
      // TODO: let the second customer describe itself.
      next.textContent = 'Next up: TODO';
      lineDisplay.append(next);
    }
  }

  countLine.textContent = `Customers in line: ${line.length}`;
  serveButton.disabled = line.isEmpty();
};

addHumanButton.addEventListener('click', () => {
  const firstName = humanFirstName.value.trim();
  const lastName = humanLastName.value.trim();

  if (firstName === '' || lastName === '') {
    message.textContent = 'Please enter a first name and a last name.';
    return;
  }

  message.textContent = '';
  // TODO: build a Human from the two names and the Long hair checkbox,
  // and send that customer to the back of the line.

  humanFirstName.value = '';
  humanLastName.value = '';
  // TODO: clear the Long hair checkbox too, so the next customer starts fresh.
  render();
});

addDogButton.addEventListener('click', () => {
  const name = dogName.value.trim();
  const breed = dogBreed.value.trim();

  if (name === '' || breed === '') {
    message.textContent = 'Please enter a name and a breed.';
    return;
  }

  message.textContent = '';
  // TODO: build a Dog from the name and the breed, and send it to the back of the line.

  dogName.value = '';
  dogBreed.value = '';
  render();
});

serveButton.addEventListener('click', () => {
  // TODO: take the customer at the front out of the line.
  render();
});

render();
