import './App.css';
import CoinFlip from './components/Coin/Coin';
import DiceRoll3D from './components/Dice/Dice';

function App() {
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
    </div>
  );
}

export default App;
