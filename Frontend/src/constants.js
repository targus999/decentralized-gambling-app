export const contractAddress = "0x6ACAB5a3C3E1961Cdb858ea210Bcd81f2d6BabDb"
export const betAmount = "0.00000005";
export const abi = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "Gamble__contract_is_busy",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "Gamble__send_more_eth",
		"type": "error"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "player",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "bet",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "enum Gamble.State",
				"name": "gameType",
				"type": "uint8"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "currentBalance",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "BetPlaced",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "player",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "bet",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "result",
				"type": "uint256"
			}
		],
		"name": "CoinFlipped",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "player",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "bet",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "result",
				"type": "uint256"
			}
		],
		"name": "DiceRolled",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "bet",
				"type": "uint256"
			}
		],
		"name": "flipCoin",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "bet",
				"type": "uint256"
			}
		],
		"name": "rollDice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "currentState",
		"outputs": [
			{
				"internalType": "enum Gamble.State",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]