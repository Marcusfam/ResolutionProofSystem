# Resolution Proof System in Prolog

This repository contains a Prolog implementation of a resolution theorem prover as part of a CS262 Logic and Verification coursework. The project is based on Exercise 3.3.3 from Fitting’s book, which provides a structured guide to developing a resolution-based theorem prover that handles various propositional logic connectives.

## Project Overview

The resolution proof system developed in this project is designed to handle negation and both primary and secondary logical connectives. It takes propositional formulas, transforms them into conjunctive normal form, and applies a resolution proof to determine the validity of the formulas.

### Features

- Transform propositional formulas into conjunctive normal form.
- Implement primary and secondary logical connectives.
- Use atomic resolution rules to validate propositions.

## Getting Started

### Prerequisites
- SWI-Prolog

### Installation
To run the program, navigate to the project directory in your terminal and start SWI-Prolog with the resolution prover file:
swipl -s resolution.pl
