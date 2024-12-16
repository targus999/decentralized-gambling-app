import { useEffect } from 'react';
import './App.css';
import CoinFlip from './components/Coin/Coin';
import DiceRoll3D from './components/Dice/Dice';
import { connectWallet } from './lib/walletConnections';
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";


function App() {
  useEffect(() => {
    document.title = "Decentralized Gambling App";
    connectWallet();
  })
  return (
    <div className="App">
      <header className="App-header">
        <h1>Decentralized Gambling App</h1>
        <div className="header-container">
          <DiceRoll3D />
          <CoinFlip />
        </div>
        <h5>
          made with ChainLink VRF | <a href="https://github.com/targus999/decentralized-gambling-app" target="_blank" rel="noopener noreferrer">GITHUB</a>
        <p style={{ fontSize: "13px", color: "gray", marginTop: "5px" }}>
        **Metamask Wallet required to play**
      </p></h5>
        
      </header>
      <ToastContainer 
        position="top-center" // Set global position to middle top
        autoClose={3000}      // Optional: Default auto-close duration
        hideProgressBar={true} // Show the progress bar
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        theme="light" // Dark mode enabled
      />
    </div>
  );
}

export default App;
