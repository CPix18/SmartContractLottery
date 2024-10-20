// Import contract address and ABI from constants.js
import { lotteryAddress, lotteryAbi } from './constants.js';

// Get the HTML elements by ID
const connectButton = document.getElementById('connectButton');
const enterLotteryButton = document.getElementById('enterLotteryButton');
const getWinnerButton = document.getElementById('getWinnerButton');
const balanceButton = document.getElementById('balanceButton'); // New button
const walletAddressDisplay = document.getElementById("walletAddress");

// Add click event listener for the connect button
connectButton.addEventListener('click', async () => {
    if (typeof window.ethereum !== "undefined") {
        try {
            const accounts = await ethereum.request({ method: "eth_requestAccounts" });
            console.log('Connected account:', accounts[0]);
            walletAddressDisplay.innerText = "Connected: " + accounts[0];
        } catch (error) {
            console.error('User rejected the request or another error occurred:', error);
        }
    } else {
        alert("Ethereum wallet is not installed. Please install MetaMask or another wallet and try again.");
    }
});

// Function to interact with the smart contract to enter the lottery
async function enterLottery() {
    if (typeof window.ethereum !== "undefined") {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = await provider.getSigner();
        const contract = new ethers.Contract(lotteryAddress, lotteryAbi, signer);
        try {
            const entranceFee = await contract.getEntranceFee();
            const transactionResponse = await contract.enterRaffle({ value: entranceFee }); // Updated function name
            await transactionResponse.wait(1); // Wait for the transaction to be mined
            console.log("Entered the lottery successfully.");
            document.getElementById("status").innerText = "Status: Entered successfully!";
        } catch (error) {
            console.error("Error entering the lottery:", error);
            document.getElementById("status").innerText = "Status: Failed to enter lottery.";
        }
    } else {
        alert("Please install MetaMask");
    }
}

// Function to get the recent winner from the smart contract
async function getRecentWinner() {
    if (typeof window.ethereum !== "undefined") {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = new ethers.Contract(lotteryAddress, lotteryAbi, provider);
        try {
            const recentWinner = await contract.getRecentWinner();
            console.log("Recent winner:", recentWinner);
            document.getElementById("winner").innerText = "Winner: " + recentWinner;
        } catch (error) {
            console.error("Error fetching recent winner:", error);
            document.getElementById("winner").innerText = "Winner: Error fetching winner.";
        }
    } else {
        alert("Please install MetaMask");
    }
}

// Function to get the contract balance
async function getLotteryBalance() {
    if (typeof window.ethereum !== "undefined") {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = new ethers.Contract(lotteryAddress, lotteryAbi, provider);
        try {
            const balance = await provider.getBalance(lotteryAddress);
            console.log("Lottery balance:", ethers.utils.formatEther(balance), "ETH");
            alert("Lottery Balance: " + ethers.utils.formatEther(balance) + " ETH");
        } catch (error) {
            console.error("Error fetching contract balance:", error);
            alert("Error fetching contract balance.");
        }
    } else {
        alert("Please install MetaMask");
    }
}

// Add event listeners for the buttons
enterLotteryButton.addEventListener('click', enterLottery);
getWinnerButton.addEventListener('click', getRecentWinner);
balanceButton.addEventListener('click', getLotteryBalance); 
