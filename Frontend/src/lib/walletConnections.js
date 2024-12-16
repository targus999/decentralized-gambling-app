import { toast } from "react-toastify";
import { ethers } from "ethers";
import { abi, betAmount, contractAddress } from "../constants.js";

export const connectWallet = async () => {
    if (window.ethereum) {
        try {
            await window.ethereum.request({ method: "eth_requestAccounts" });
        } catch (error) {
            console.log(error);
        }
    } else {
        toast.error("No Compatible Wallet Detected", {
            toastId: 'noWalletError'
        });
    }
};
export const checkWalletConnection = async () => {
    let walletConnected = false;
    if (window.ethereum) {
        const accounts = await window.ethereum.request({ method: "eth_accounts" });
        if (accounts.length > 0) {
            walletConnected = true;
        }
    }
    return walletConnected;
};
export async function rollingDice(bet) {
    if (typeof window.ethereum !== "undefined") {
        const provider = new ethers.BrowserProvider(window.ethereum)
        await provider.send('eth_requestAccounts', [])
        const signer = await provider.getSigner()
        const contract = new ethers.Contract(contractAddress, abi, signer)
        try {
            console.log(betAmount);

            const transactionResponse = await contract.rollDice(bet, {
                value: ethers.parseEther(betAmount),
            })
            // Wait for the transaction to be mined
            const receipt = await transactionResponse.wait(1);
            console.log("Transaction confirmed:", receipt);

            // Filter the `DiceRolled` event from the logs
            const event = receipt.logs.find((log) =>
                log.topics[0] === ethers.id("DiceRolled(address,uint256,uint256)")
            );

            if (event) {
                const decoded = contract.interface.decodeEventLog(
                    "DiceRolled",
                    event.data,
                    event.topics
                );

                console.log("Dice Rolled:", decoded.result.toString());
                return decoded.result.toString(); // The returned value
            }
        } catch (error) {
            console.log(error)
        }
    }
}

export async function flippingCoin(bet) {
    if (typeof window.ethereum !== "undefined") {
        const provider = new ethers.BrowserProvider(window.ethereum)
        await provider.send('eth_requestAccounts', [])
        const signer = await provider.getSigner()
        const contract = new ethers.Contract(contractAddress, abi, signer)
        try {
            console.log(betAmount);

            const transactionResponse = await contract.flipCoin(bet, {
                value: ethers.parseEther(betAmount),
            })
            // Wait for the transaction to be mined
            const receipt = await transactionResponse.wait(1);
            console.log("Transaction confirmed:", receipt);

            // Filter the `CoinFlipped` event from the logs
            const event = receipt.logs.find((log) =>
                log.topics[0] === ethers.id("CoinFlipped(address,uint256,uint256)")
            );

            if (event) {
                const decoded = contract.interface.decodeEventLog(
                    "CoinFlipped",
                    event.data,
                    event.topics
                );

                console.log("CoinFlipped:", decoded.result.toString());
                return decoded.result.toString(); // The returned value
            }
        } catch (error) {
            console.log(error)
        }
    }

}