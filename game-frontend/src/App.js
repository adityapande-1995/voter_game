import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const App = () => {
    const [position, setPosition] = useState({ top: 50, left: 50 });
    const [votes, setVotes] = useState({ up: 0, down: 0, left: 0, right: 0 });

    useEffect(() => {
        const interval = setInterval(() => {
            axios.get('http://localhost:8080/votes')
                .then(response => {
                    const newDirection = response.data.direction;
                    setVotes(response.data.votes);
                    moveSquare(newDirection);
                })
                .catch(error => {
                    console.error('Error fetching votes:', error);
                });
        }, 1000);

        return () => clearInterval(interval);
    }, []);

    const moveSquare = (direction) => {
        setPosition(prevPosition => {
            let newTop = prevPosition.top;
            let newLeft = prevPosition.left;

            // Adjust the square size and screen limits
            const squareSize = 5; // in percentage
            const screenLimit = 100;

            if (direction === 'up' && newTop > 0) newTop -= 5;
            if (direction === 'down' && newTop < screenLimit - squareSize) newTop += 5;
            if (direction === 'left' && newLeft > 0) newLeft -= 5;
            if (direction === 'right' && newLeft < screenLimit - squareSize) newLeft += 5;

            return { top: newTop, left: newLeft };
        });
    };

    const sendVote = (direction) => {
        axios.post('http://localhost:8080/vote', { direction })
            .then(() => {
                console.log(`Vote for ${direction} sent`);
            })
            .catch((error) => {
                console.error('Error sending vote:', error);
            });
    };

    return (
        <div className="App">
            <div
                className="square"
                style={{ top: `${position.top}%`, left: `${position.left}%` }}
            ></div>
            <div className="controls">
                <button onClick={() => sendVote('up')}>Up</button>
                <button onClick={() => sendVote('down')}>Down</button>
                <button onClick={() => sendVote('left')}>Left</button>
                <button onClick={() => sendVote('right')}>Right</button>
            </div>
            <div className="votes">
                <p>Up: {votes.up}</p>
                <p>Down: {votes.down}</p>
                <p>Left: {votes.left}</p>
                <p>Right: {votes.right}</p>
            </div>
        </div>
    );
};

export default App;
