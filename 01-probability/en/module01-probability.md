# Module 1 — Probability

## Learning Objectives

After completing this module, students will be able to:

1. Define random experiments and identify sample spaces for engineering scenarios
2. Apply set operations to define complex events
3. Use probability axioms to derive probability rules
4. Compute conditional probabilities
5. Determine statistical independence
6. Apply Bayes' theorem to engineering inference problems
7. Use the total probability theorem for multi-path analysis
8. Simulate random experiments in MATLAB

---

## 1.1 Introduction: Why Probability in Engineering?

### The Engineering Reality

No engineering system operates in a perfectly deterministic world. Consider:

- A digital communication system transmits bits, but **noise** corrupts some bits randomly
- A manufacturing line produces resistors, but their values **vary** around the nominal
- A sensor measures temperature, but each reading has **random error**
- A wireless signal travels to a receiver, but **fading** causes random attenuation

**Probability theory** provides the mathematical framework to model, analyze, and design systems that operate under uncertainty.

### Engineering Question

> "If I transmit 1000 bits over a noisy channel, how many errors should I expect? Can I guarantee fewer than 5 errors?"

To answer this, we need:
1. A model of the random phenomenon (bit errors)
2. Mathematical tools to compute probabilities
3. Methods to make engineering decisions based on those probabilities

---

## 1.2 Random Experiments

### Definition

A **random experiment** is a procedure that:
1. Can be repeated under identical conditions
2. Has a well-defined set of possible outcomes
3. Has an outcome that cannot be predicted with certainty before the experiment is performed

### Engineering Examples

| Experiment | Context | Uncertainty Source |
|-----------|---------|-------------------|
| Transmit one bit over a noisy channel | Communications | Thermal noise |
| Measure a resistor's value | Electronics | Manufacturing variation |
| Count packets arriving in 1 second | Networking | Traffic randomness |
| Measure received signal power | Wireless | Fading, interference |
| Test a component until failure | Reliability | Material defects, wear |
| Sample ADC output voltage | Signal processing | Quantization + noise |

### Key Distinction

| Deterministic | Random |
|--------------|--------|
| Output of a logic gate with known inputs | Output of a logic gate with noisy inputs |
| Resistance calculated from color code | Actual measured resistance |
| Free-space path loss at known distance | Actual received power with fading |

---

## 1.3 Sample Spaces

### Definition

The **sample space** S (or Ω) is the set of all possible outcomes of a random experiment.

### Types of Sample Spaces

**Discrete (Countable):**

- Transmit one bit: S = {0, 1} (received correctly or in error)
- Number of errors in a packet of n bits: S = {0, 1, 2, ..., n}
- Number of arrivals at a server: S = {0, 1, 2, 3, ...}

**Continuous (Uncountable):**

- Measured voltage: S = ℝ (or a practical range like [0, 5] V)
- Time until component failure: S = [0, ∞)
- Phase of received signal: S = [0, 2π)

### Engineering Example: Communication System

A transmitter sends a bit (0 or 1) over a noisy channel. The receiver makes a decision.

```{.figure #m01-sample-space}
Sample Space for (transmitted, received) pairs:
S = {(0,0), (0,1), (1,0), (1,1)}

Where:
  (0,0) = transmitted 0, received 0 (correct)
  (0,1) = transmitted 0, received 1 (error)
  (1,0) = transmitted 1, received 0 (error)
  (1,1) = transmitted 1, received 1 (correct)
```

---

## 1.4 Events

### Definition

An **event** is a subset of the sample space. An event **occurs** if the outcome of the experiment belongs to that subset.

### Types of Events

- **Simple event**: Contains exactly one outcome. E = {(0,1)}
- **Compound event**: Contains multiple outcomes. E = {(0,1), (1,0)} (any error)
- **Certain event**: The entire sample space S (always occurs)
- **Impossible event**: The empty set ∅ (never occurs)

### Set Operations on Events

| Operation | Notation | Meaning | Engineering Interpretation |
|-----------|----------|---------|---------------------------|
| Union | A ∪ B | A or B (or both) occurs | Either failure mode A or B triggers alarm |
| Intersection | A ∩ B | Both A and B occur | Both sensors detect the signal |
| Complement | Aᶜ or Ā | A does not occur | Component does NOT fail |
| Difference | A - B = A ∩ Bᶜ | A occurs but not B | Sensor A triggers but sensor B doesn't |
| Mutually exclusive | A ∩ B = ∅ | A and B cannot both occur | Component can't be both working and failed |

### Engineering Example: Manufacturing Defects

A circuit board inspection checks for three types of defects:
- A = solder bridge defect
- B = missing component
- C = wrong component value

Events:
- A ∪ B ∪ C = "board has at least one defect"
- A ∩ B = "board has both a solder bridge AND a missing component"
- (A ∪ B ∪ C)ᶜ = "board is defect-free"

---

## 1.5 Probability Axioms

### Kolmogorov's Axioms

For a sample space S with events defined on it, a probability function P satisfies:

**Axiom 1 (Non-negativity):**
$$P(A) \geq 0 \quad \text{for any event } A$$

**Axiom 2 (Normalization):**
$$P(S) = 1$$

**Axiom 3 (Countable Additivity):**
For mutually exclusive events A₁, A₂, A₃, ...:
$$P(A_1 \cup A_2 \cup A_3 \cup \cdots) = P(A_1) + P(A_2) + P(A_3) + \cdots$$

### Properties Derived from Axioms

**Property 1: Complement Rule**
$$P(A^c) = 1 - P(A)$$

*Proof:* S = A ∪ Aᶜ and A ∩ Aᶜ = ∅, so P(S) = P(A) + P(Aᶜ) = 1.

*Engineering meaning:* P(component works) = 1 - P(component fails)

**Property 2: Impossible Event**
$$P(\emptyset) = 0$$

**Property 3: Monotonicity**
If A ⊆ B, then P(A) ≤ P(B)

**Property 4: Bound**
$$0 \leq P(A) \leq 1$$

**Property 5: Inclusion-Exclusion (Two Events)**
$$P(A \cup B) = P(A) + P(B) - P(A \cap B)$$

*Engineering meaning:* When computing the probability of "failure A OR failure B," we must subtract the overlap where both fail simultaneously.

---

## 1.6 Probability Rules

### Addition Rule

For any two events:
$$P(A \cup B) = P(A) + P(B) - P(A \cap B)$$

For mutually exclusive events (A ∩ B = ∅):
$$P(A \cup B) = P(A) + P(B)$$

### Complement Rule

$$P(A) = 1 - P(A^c)$$

This is often the easiest way to compute probabilities:

> P(at least one error in 100 bits) = 1 - P(zero errors in 100 bits)

### Inclusion-Exclusion (Three Events)

$$P(A \cup B \cup C) = P(A) + P(B) + P(C) - P(A \cap B) - P(A \cap C) - P(B \cap C) + P(A \cap B \cap C)$$

### Engineering Example: Network Redundancy

A data center has three independent network links. Each link fails with probability 0.05.

- A = link 1 fails, B = link 2 fails, C = link 3 fails
- P(at least one fails) = P(A ∪ B ∪ C)
- Using inclusion-exclusion:

P(A ∪ B ∪ C) = 3(0.05) - 3(0.05)² + (0.05)³ = 0.15 - 0.0075 + 0.000125 = 0.142625

Alternatively: P(at least one fails) = 1 - P(none fail) = 1 - (0.95)³ = 0.142625 ✓



---

## 1.7 Conditional Probability

### Definition

The **conditional probability** of event A given that event B has occurred:

$$P(A|B) = \frac{P(A \cap B)}{P(B)}, \quad P(B) > 0$$

### Interpretation

Conditional probability **updates** our knowledge. Once we know B occurred, the effective sample space shrinks from S to B, and we ask: "Within B, how likely is A?"

### Key Distinction

| Concept | Notation | Meaning |
|---------|----------|---------|
| Probability of A | P(A) | Likelihood of A with no additional information |
| Conditional probability | P(A\|B) | Likelihood of A **given** that B has occurred |
| Joint probability | P(A ∩ B) | Likelihood that **both** A and B occur |

These are related: P(A ∩ B) = P(A|B) · P(B) = P(B|A) · P(A)

### Engineering Example: Detection Theory

A radar system detects aircraft:
- H₁ = aircraft is present (target)
- H₀ = aircraft is absent (no target)
- D = detector says "target present"

Important conditional probabilities:
- P(D | H₁) = **probability of detection** (sensitivity)
- P(D | H₀) = **probability of false alarm**
- P(Dᶜ | H₁) = **probability of miss** = 1 - P(D | H₁)

Suppose: P(H₁) = 0.01, P(D|H₁) = 0.95, P(D|H₀) = 0.02

What is P(target actually present | detector says present)?

This requires **Bayes' theorem** (Section 1.9).

### Engineering Example: Communication Channel

A binary symmetric channel has crossover probability p = 0.01:
- P(receive 1 | sent 0) = p = 0.01
- P(receive 0 | sent 1) = p = 0.01
- P(receive 0 | sent 0) = 1 - p = 0.99
- P(receive 1 | sent 1) = 1 - p = 0.99

If bits are equally likely to be 0 or 1:
- P(sent 0 ∩ receive 1) = P(receive 1 | sent 0) · P(sent 0) = 0.01 × 0.5 = 0.005
- P(error) = P(sent 0 ∩ receive 1) + P(sent 1 ∩ receive 0) = 0.005 + 0.005 = 0.01

### Properties of Conditional Probability

Conditional probability is itself a valid probability measure:
1. P(A|B) ≥ 0
2. P(S|B) = 1
3. P(A₁ ∪ A₂|B) = P(A₁|B) + P(A₂|B) if A₁ ∩ A₂ = ∅

### Multiplication Rule (Chain Rule)

$$P(A \cap B) = P(A|B) \cdot P(B) = P(B|A) \cdot P(A)$$

For three events:
$$P(A \cap B \cap C) = P(A) \cdot P(B|A) \cdot P(C|A \cap B)$$

---

## 1.8 Independence

### Definition

Events A and B are **statistically independent** if:

$$P(A \cap B) = P(A) \cdot P(B)$$

Equivalently: P(A|B) = P(A) — knowing B occurred gives no information about A.

### Engineering Significance

Independence means **one event provides no information about the other**. This is a modeling assumption we often make:

- Noise samples at different times are independent
- Bit errors in different time slots are independent (memoryless channel)
- Component failures in different subsystems are independent

### Pairwise vs. Mutual Independence

For three events A, B, C:

**Pairwise independence** (all three pairs):
- P(A ∩ B) = P(A)P(B)
- P(A ∩ C) = P(A)P(C)
- P(B ∩ C) = P(B)P(C)

**Mutual independence** (all combinations):
- All pairwise conditions above, AND
- P(A ∩ B ∩ C) = P(A)P(B)P(C)

> ⚠️ Pairwise independence does NOT imply mutual independence!

### Engineering Example: Independent Component Failures

A system has three independent modules, each with failure probability 0.1.

P(all three fail) = P(A)P(B)P(C) = (0.1)³ = 0.001

P(system works) = P(at least one works) = 1 - P(all fail) = 1 - 0.001 = 0.999

This calculation is ONLY valid because failures are independent.

### Testing Independence

To verify independence from data:
1. Compute P(A), P(B), and P(A ∩ B) empirically
2. Check if P(A ∩ B) ≈ P(A) · P(B)

If not approximately equal, the events are **dependent**.

### Common Misconception

> ❌ "Mutually exclusive events are independent"

This is **FALSE**. If A ∩ B = ∅ and P(A) > 0, P(B) > 0, then:
- P(A ∩ B) = 0
- P(A)P(B) > 0
- Therefore P(A ∩ B) ≠ P(A)P(B)

Mutually exclusive events are actually **maximally dependent** — if one occurs, the other cannot.

---

## 1.9 Bayes' Theorem

### Derivation

From the definition of conditional probability:

$$P(A|B) = \frac{P(A \cap B)}{P(B)} = \frac{P(B|A) \cdot P(A)}{P(B)}$$

### Full Statement

If B₁, B₂, ..., Bₙ partition the sample space (mutually exclusive and exhaustive):

$$P(B_i|A) = \frac{P(A|B_i) \cdot P(B_i)}{\sum_{j=1}^{n} P(A|B_j) \cdot P(B_j)}$$

### Terminology

| Term | Name | Engineering Meaning |
|------|------|---------------------|
| P(Bᵢ) | Prior probability | What we believed before observing data |
| P(A\|Bᵢ) | Likelihood | How likely is the observation given each hypothesis |
| P(Bᵢ\|A) | Posterior probability | Updated belief after observing data |
| P(A) | Evidence | Total probability of the observation |

### Engineering Example: Fault Diagnosis

A circuit board can have a fault in one of three subsystems:
- B₁ = power supply fault, P(B₁) = 0.3
- B₂ = processor fault, P(B₂) = 0.5
- B₃ = memory fault, P(B₃) = 0.2

A diagnostic test produces symptom A (overheating):
- P(A|B₁) = 0.8 (power supply faults usually cause overheating)
- P(A|B₂) = 0.3 (processor faults sometimes cause overheating)
- P(A|B₃) = 0.1 (memory faults rarely cause overheating)

**Question:** Given that overheating is observed, what is the most likely fault?

**Solution:**

P(A) = P(A|B₁)P(B₁) + P(A|B₂)P(B₂) + P(A|B₃)P(B₃)
     = (0.8)(0.3) + (0.3)(0.5) + (0.1)(0.2)
     = 0.24 + 0.15 + 0.02 = 0.41

P(B₁|A) = (0.8)(0.3) / 0.41 = 0.585 (most likely!)
P(B₂|A) = (0.3)(0.5) / 0.41 = 0.366
P(B₃|A) = (0.1)(0.2) / 0.41 = 0.049

**Engineering Decision:** Investigate the power supply first.

### Engineering Example: Detection with Bayes

Returning to the radar example from Section 1.7:
- P(H₁) = 0.01, P(D|H₁) = 0.95, P(D|H₀) = 0.02

P(D) = P(D|H₁)P(H₁) + P(D|H₀)P(H₀) = (0.95)(0.01) + (0.02)(0.99) = 0.0095 + 0.0198 = 0.0293

P(H₁|D) = (0.95)(0.01) / 0.0293 = 0.324

**Interpretation:** Even with a good detector (95% detection, 2% false alarm), when targets are rare (1%), most detections are false alarms! Only 32.4% of alarms correspond to real targets.

**Engineering Lesson:** System design must account for **prior probabilities**, not just detector performance.



---

## 1.10 Total Probability Theorem

### Statement

If B₁, B₂, ..., Bₙ form a **partition** of S (mutually exclusive, exhaustive):

$$P(A) = \sum_{i=1}^{n} P(A|B_i) \cdot P(B_i)$$

### Interpretation

To find the total probability of event A, decompose into all possible "paths" to A through the partition.

### Engineering Example: Multi-Path Communication

A packet can be routed through three different paths:
- Path 1: chosen 50% of the time, error probability 0.01
- Path 2: chosen 30% of the time, error probability 0.05
- Path 3: chosen 20% of the time, error probability 0.10

P(packet error) = P(error|path 1)P(path 1) + P(error|path 2)P(path 2) + P(error|path 3)P(path 3)
                = (0.01)(0.50) + (0.05)(0.30) + (0.10)(0.20)
                = 0.005 + 0.015 + 0.020 = 0.040

**Overall error rate: 4%**

### Engineering Example: Manufacturing with Multiple Suppliers

A company sources capacitors from two suppliers:
- Supplier A: provides 60% of capacitors, defect rate 2%
- Supplier B: provides 40% of capacitors, defect rate 5%

P(defective) = P(defective|A)P(A) + P(defective|B)P(B)
             = (0.02)(0.60) + (0.05)(0.40)
             = 0.012 + 0.020 = 0.032

If a defective capacitor is found, which supplier likely produced it?

P(A|defective) = (0.02)(0.60) / 0.032 = 0.375
P(B|defective) = (0.05)(0.40) / 0.032 = 0.625

Despite providing fewer units, Supplier B is more likely responsible for a given defect.

---

## 1.11 MATLAB Examples

### Example 1: Simulating Coin Flips (Random Experiment)

```matlab
%% Simulating a Random Experiment: Biased Coin
% A communication channel has bit error probability p = 0.1
% Simulate transmitting N bits and count errors

p = 0.1;          % Bit error probability
N = 10000;        % Number of bits transmitted

% Generate random outcomes: 1 = error, 0 = correct
errors = rand(1, N) < p;

% Empirical probability of error
p_empirical = sum(errors) / N;

fprintf('Theoretical P(error) = %.4f\n', p);
fprintf('Empirical P(error)   = %.4f (from %d trials)\n', p_empirical, N);
fprintf('Difference           = %.4f\n', abs(p - p_empirical));
```

### Example 2: Verifying the Addition Rule

```matlab
%% Verifying Inclusion-Exclusion with Simulation
% Two independent failure modes:
% A = overheating (P = 0.05)
% B = power surge (P = 0.03)

N = 100000;       % Number of trials
pA = 0.05;
pB = 0.03;

% Generate independent failures
A = rand(1, N) < pA;
B = rand(1, N) < pB;

% Empirical probabilities
pA_emp = mean(A);
pB_emp = mean(B);
pAB_emp = mean(A & B);           % Both occur
pAuB_emp = mean(A | B);          % At least one occurs

% Theoretical (independent)
pAB_theory = pA * pB;
pAuB_theory = pA + pB - pA*pB;

fprintf('P(A ∩ B): Theory = %.5f, Empirical = %.5f\n', pAB_theory, pAB_emp);
fprintf('P(A ∪ B): Theory = %.5f, Empirical = %.5f\n', pAuB_theory, pAuB_emp);
```

### Example 3: Conditional Probability Simulation

```matlab
%% Conditional Probability: Binary Symmetric Channel
% P(error | sent 0) = P(error | sent 1) = p = 0.1

p_crossover = 0.1;
N = 100000;

% Randomly generate transmitted bits (equally likely 0 or 1)
transmitted = randi([0, 1], 1, N);

% Channel: flip each bit with probability p_crossover
noise = rand(1, N) < p_crossover;
received = xor(transmitted, noise);

% Compute conditional probabilities
sent_0_idx = (transmitted == 0);
sent_1_idx = (transmitted == 1);

% P(received = 1 | sent = 0)
p_1_given_sent0 = mean(received(sent_0_idx));
% P(received = 0 | sent = 1)  
p_0_given_sent1 = mean(received(sent_1_idx));

fprintf('P(receive 1 | sent 0) = %.4f (theory: %.4f)\n', p_1_given_sent0, p_crossover);
fprintf('P(receive 0 | sent 1) = %.4f (theory: %.4f)\n', p_0_given_sent1, p_crossover);
```

### Example 4: Bayes' Theorem Simulation

```matlab
%% Bayes' Theorem: Fault Diagnosis Simulation
N = 100000;

% Prior probabilities of fault types
p_power = 0.3;   p_proc = 0.5;   p_mem = 0.2;

% Likelihoods of symptom (overheating) given fault type
p_sym_power = 0.8;  p_sym_proc = 0.3;  p_sym_mem = 0.1;

% Simulate: generate fault type for each trial
fault_type = zeros(1, N);
r = rand(1, N);
fault_type(r < p_power) = 1;                          % Power supply
fault_type(r >= p_power & r < p_power + p_proc) = 2;  % Processor
fault_type(r >= p_power + p_proc) = 3;                % Memory

% Generate symptom based on fault type
symptom = zeros(1, N);
symptom(fault_type == 1) = rand(1, sum(fault_type==1)) < p_sym_power;
symptom(fault_type == 2) = rand(1, sum(fault_type==2)) < p_sym_proc;
symptom(fault_type == 3) = rand(1, sum(fault_type==3)) < p_sym_mem;

% Compute posterior: P(fault_type | symptom = 1)
sym_idx = logical(symptom);
p_power_given_sym = mean(fault_type(sym_idx) == 1);
p_proc_given_sym = mean(fault_type(sym_idx) == 2);
p_mem_given_sym = mean(fault_type(sym_idx) == 3);

% Theoretical values
p_sym = p_sym_power*p_power + p_sym_proc*p_proc + p_sym_mem*p_mem;
theory_power = p_sym_power*p_power / p_sym;
theory_proc = p_sym_proc*p_proc / p_sym;
theory_mem = p_sym_mem*p_mem / p_sym;

fprintf('P(power fault | symptom): Empirical = %.3f, Theory = %.3f\n', p_power_given_sym, theory_power);
fprintf('P(proc fault  | symptom): Empirical = %.3f, Theory = %.3f\n', p_proc_given_sym, theory_proc);
fprintf('P(mem fault   | symptom): Empirical = %.3f, Theory = %.3f\n', p_mem_given_sym, theory_mem);
```

### Example 5: Independence Test

```matlab
%% Testing Independence vs. Dependence
N = 100000;

% Case 1: Independent events
A_ind = rand(1, N) < 0.3;
B_ind = rand(1, N) < 0.4;  % Generated independently

pA = mean(A_ind);
pB = mean(B_ind);
pAB = mean(A_ind & B_ind);
fprintf('Independent case:\n');
fprintf('  P(A)*P(B) = %.4f, P(A∩B) = %.4f\n', pA*pB, pAB);

% Case 2: Dependent events (B depends on A)
A_dep = rand(1, N) < 0.3;
B_dep = zeros(1, N);
B_dep(A_dep == 1) = rand(1, sum(A_dep)) < 0.7;   % P(B|A) = 0.7
B_dep(A_dep == 0) = rand(1, sum(~A_dep)) < 0.2;  % P(B|not A) = 0.2

pA = mean(A_dep);
pB = mean(B_dep);
pAB = mean(A_dep & B_dep);
fprintf('Dependent case:\n');
fprintf('  P(A)*P(B) = %.4f, P(A∩B) = %.4f\n', pA*pB, pAB);
fprintf('  These differ => events are dependent\n');
```

---

## 1.12 Summary: Key Distinctions

| Concept | Definition | Engineering Meaning |
|---------|-----------|---------------------|
| **Event** | A subset of the sample space | A specific outcome or set of outcomes we care about |
| **Probability** | P(A) = measure of likelihood | Long-run relative frequency of occurrence |
| **Conditional Probability** | P(A\|B) = updated probability given B | How knowledge of one event changes another's likelihood |
| **Independence** | P(A∩B) = P(A)P(B) | Knowing one event tells nothing about the other |

---

## 1.13 Practice Problems

### Problem 1: Component Reliability
A system has two independent processors. Processor 1 fails with probability 0.02, Processor 2 fails with probability 0.03. The system fails only if BOTH processors fail.

(a) What is the probability that the system fails?
(b) What is the probability that at least one processor fails?
(c) Given that the system is still working, what is the probability that processor 1 has failed?

**Solution:**
(a) P(system fails) = P(both fail) = (0.02)(0.03) = 0.0006

(b) P(at least one fails) = 1 - P(none fail) = 1 - (0.98)(0.97) = 1 - 0.9506 = 0.0494

(c) System working = NOT(both fail) = at least one works.
P(P1 failed | system works) = P(P1 failed ∩ P2 works) / P(system works)
= (0.02)(0.97) / (1 - 0.0006) = 0.0194 / 0.9994 ≈ 0.0194

---

### Problem 2: Sensor Detection
A fire detection system has: P(fire) = 0.001, P(alarm | fire) = 0.98, P(alarm | no fire) = 0.01.

(a) What is P(alarm)?
(b) If the alarm sounds, what is P(fire | alarm)?
(c) Comment on the result.

**Solution:**
(a) P(alarm) = P(alarm|fire)P(fire) + P(alarm|no fire)P(no fire)
= (0.98)(0.001) + (0.01)(0.999) = 0.000980 + 0.009990 = 0.010970

(b) P(fire|alarm) = P(alarm|fire)P(fire) / P(alarm)
= (0.98)(0.001) / 0.01097 = 0.0894

(c) Only ~9% of alarms correspond to real fires! This is the base rate fallacy. Even with an excellent detector, rare events produce many false alarms.

---

### Problem 3: Communication Error
A packet of 8 bits is transmitted. Each bit has independent error probability 0.05.

(a) What is P(no errors in the packet)?
(b) What is P(exactly one error)?
(c) What is P(at least one error)?
(d) Write MATLAB code to verify by simulation.

**Solution:**
(a) P(no errors) = (0.95)⁸ = 0.6634

(b) P(exactly one error) = C(8,1)(0.05)¹(0.95)⁷ = 8 × 0.05 × 0.6983 = 0.2793

(c) P(at least one error) = 1 - P(no errors) = 1 - 0.6634 = 0.3366

(d) MATLAB verification:
```matlab
p = 0.05; n_bits = 8; N_packets = 100000;
errors_per_packet = sum(rand(n_bits, N_packets) < p, 1);
fprintf('P(0 errors) = %.4f (theory: %.4f)\n', mean(errors_per_packet==0), 0.95^8);
fprintf('P(1 error)  = %.4f (theory: %.4f)\n', mean(errors_per_packet==1), 8*0.05*0.95^7);
fprintf('P(>=1 error)= %.4f (theory: %.4f)\n', mean(errors_per_packet>=1), 1-0.95^8);
```

---

### Problem 4: Total Probability Application
A wireless system operates in three modes:
- Mode 1 (good channel): 60% of time, P(outage) = 0.01
- Mode 2 (moderate channel): 30% of time, P(outage) = 0.10
- Mode 3 (poor channel): 10% of time, P(outage) = 0.50

(a) What is the overall outage probability?
(b) Given an outage occurred, what is the probability the system was in Mode 3?

**Solution:**
(a) P(outage) = (0.01)(0.60) + (0.10)(0.30) + (0.50)(0.10) = 0.006 + 0.030 + 0.050 = 0.086

(b) P(Mode 3 | outage) = (0.50)(0.10) / 0.086 = 0.581

---

### Problem 5: Independence Analysis
Two sensors monitor a process. Sensor A has false alarm probability 0.05. Sensor B has false alarm probability 0.03.

(a) If sensors are independent, what is P(both give false alarm)?
(b) If sensors share a noise source and P(both false alarm) = 0.01, are they independent?
(c) What is P(A false alarm | B false alarm) in case (b)?

**Solution:**
(a) If independent: P(both) = (0.05)(0.03) = 0.0015

(b) If P(both) = 0.01 ≠ 0.0015, they are NOT independent. The shared noise source creates dependence.

(c) P(A|B) = P(A∩B) / P(B) = 0.01 / 0.03 = 0.333

This is much higher than P(A) = 0.05, confirming strong dependence.

---

## 1.14 Key Takeaways

1. **Probability quantifies uncertainty** — essential for engineering design under uncertainty
2. **Conditional probability updates beliefs** — the foundation of detection, estimation, and diagnosis
3. **Independence simplifies analysis** — but must be justified, not assumed
4. **Bayes' theorem inverts conditional probabilities** — from "likelihood of evidence given cause" to "likelihood of cause given evidence"
5. **Base rates matter** — even good detectors produce false alarms when events are rare
6. **Simulation validates analysis** — MATLAB Monte Carlo confirms theoretical calculations

---

*Next Module: [Module 2 — One Random Variable and Its Functions](module02-one-random-variable.md)*
