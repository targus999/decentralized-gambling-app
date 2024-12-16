import React, { useState } from "react";
import { motion } from "framer-motion";
import Confetti from "react-confetti";
import { checkWalletConnection, rollingDice } from "../../lib/walletConnections";
import { toast } from "react-toastify";

const DiceRoll3D = () => {
  const [selectedNumber, setSelectedNumber] = useState("1");
  const [number, setNumber] = useState("1"); // Current dice face (1-6)
  const [isRolling, setIsRolling] = useState(false);
  const [showCelebration, setShowCelebration] = useState(false);
  const [showMortification, setShowMortification] = useState(false);


  const rollDice = async () => {
    const walletConnected = await checkWalletConnection();
    if (!walletConnected) {
      console.log("Please connect your wallet!");
      toast.error("Please connect to your cryptowallet!", {
        toastId: 'walletConnectionError'
      });
      return;
    }
    setIsRolling(true);

    // calling the ABI function
    const result = await rollingDice(selectedNumber);
    // const result = 5;
    setNumber(result);
    console.log(result, selectedNumber);

    if (!result) return;
    if (result == selectedNumber) {
      setShowCelebration(true);
      setTimeout(() => setShowCelebration(false), 5000); // Show confetti if it matches
    }
    else {
      setShowMortification(true); // Show mortification
      setTimeout(() => setShowMortification(false), 2000);
    }
    // After receiving the API result, stop rolling and set the number

    setIsRolling(false);
  };

  const handleSelectChange = (event) => {
    setSelectedNumber(event.target.value); // Update selected side based on dropdown
  };


  // Define the 3D rotation for each face
  const faceRotation = {
    1: { rotateX: 0, rotateY: 0 },
    2: { rotateX: 0, rotateY: 90 },
    3: { rotateX: -90, rotateY: 0 },
    4: { rotateX: 90, rotateY: 0 },        
    5: { rotateX: 0, rotateY: -90 },      
    6: { rotateX: 0, rotateY: 180 },
};

const styles = {
  container: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    gap: "20px",
    // marginTop: "50px",
  },
  scene: {
    perspective: "1000px",
  },
  dice: {
    width: "150px",
    height: "150px",
    position: "relative",
    transformStyle: "preserve-3d",
  },
  face: {
    position: "absolute",
    width: "150px",
    height: "150px",
    backgroundColor: "silver",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    fontSize: "50px",
    fontWeight: "bold",
    color: "black",
    border: "2px solid black",
  },
  front: { transform: "rotateY(0deg) translateZ(75px)" },
  back: { transform: "rotateY(180deg) translateZ(75px)" },
  left: { transform: "rotateY(-90deg) translateZ(75px)" },
  right: { transform: "rotateY(90deg) translateZ(75px)" },
  top: { transform: "rotateX(90deg) translateZ(75px)" },
  bottom: { transform: "rotateX(-90deg) translateZ(75px)" },
  dropdown: {
    padding: "10px",
    fontSize: "16px",
    borderRadius: "5px",
    border: "1px solid #ccc",
    marginTop: "20px",
  },
  button: {
    // marginTop: "30px",
    padding: "10px 20px",
    fontSize: "16px",
    border: "none",
    borderRadius: "5px",
    backgroundColor: "#2ecc71",
    color: "white",
    cursor: "pointer",
  },
  winText: {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    fontSize: "60px",
    fontWeight: "bold",
    color: "#2ecc71",
    zIndex: 10,
  },
  failText: {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    fontSize: "60px",
    fontWeight: "bold",
    color: "red",
    zIndex: 10,
  }
};

return (
  <div style={styles.container}>
    <div style={styles.scene}>
      <h3>Dice Roll</h3>
      <motion.div
        className="dice"
        animate={
          isRolling
            ? {
              rotateX: [0, 360, 720], // Keeps rotating continuously
              rotateY: [0, 360, 720],
            }
            : faceRotation[number] // Stops at the correct face
        }
        transition={{
          duration: isRolling ? 1 : 0.5, // 1 second per loop while rolling
          ease: "linear", // Smooth continuous motion
          repeat: isRolling ? Infinity : 0, // Repeat infinitely if rolling
        }}
        style={styles.dice}
      >
        {/* Dice faces */}
        <div style={{ ...styles.face, ...styles.front }}>1</div>
        <div style={{ ...styles.face, ...styles.back }}>6</div>
        <div style={{ ...styles.face, ...styles.left }}>2</div>
        <div style={{ ...styles.face, ...styles.right }}>5</div>
        <div style={{ ...styles.face, ...styles.top }}>3</div>
        <div style={{ ...styles.face, ...styles.bottom }}>4</div>
      </motion.div>
    </div>

    {/* Dropdown for value */}
    <select
      value={selectedNumber}
      onChange={handleSelectChange}
      style={styles.dropdown}
    >
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3">3</option>
      <option value="4">4</option>
      <option value="5">5</option>
      <option value="6">6</option>
    </select>

    <button onClick={rollDice} disabled={isRolling} style={styles.button}>
      {isRolling ? "Rolling..." : "Roll Dice"}
    </button>

    {/* Show confetti if the selected side matches the rolled side */
      showCelebration && <><Confetti
        width={window.innerWidth - 10} // Set the width to the window size
        height={window.innerHeight - 10} // Set the height to the window size
      />
        <motion.div
          key="winText"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 1 }}
          style={styles.winText}
        >
          YOU WON
        </motion.div></>}

    {/* ShowMortification when user fails*/
      showMortification && <>
        <motion.div
          key="failText"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 1 }}
          style={styles.failText}
        >
          YOU FAILED
        </motion.div></>}

  </div>
);
};

export default DiceRoll3D;
