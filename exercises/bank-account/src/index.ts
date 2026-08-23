import './styles.css';

const account = { balance: 100 };

const balanceLine = document.querySelector<HTMLParagraphElement>('#balanceLine');
const amountInput = document.querySelector<HTMLInputElement>('#amount');
const depositButton = document.querySelector<HTMLButtonElement>('#depositButton');
const withdrawButton = document.querySelector<HTMLButtonElement>('#withdrawButton');
const message = document.querySelector<HTMLParagraphElement>('#message');

if (!balanceLine || !amountInput || !depositButton || !withdrawButton || !message) {
  throw new Error('The page is missing an element');
}

const showBalance = () => {
  balanceLine.textContent = `Balance: ${account.balance}`;
};

depositButton.addEventListener('click', () => {
  account.balance += amountInput.valueAsNumber;
  message.textContent = '';
  showBalance();
});

withdrawButton.addEventListener('click', () => {
  account.balance -= amountInput.valueAsNumber;
  message.textContent = '';
  showBalance();
});

showBalance();
