# Rebuttal

Thank you for your thoughtful comments and suggestions. Some comments answers follow.

[R1] How can these models extend to k-cycles and longer chains?

For the direct prediction method, extension is straightforward. Note we are predicting which *pairs* should be matched today, so whether they are matched in 2-cycles, longer cycles, or as part of a chain is immaterial. In fact, Algorithm 1 and its description on Figure 3 would remain unchanged -- including the matrices X_t, E^1_t and E^2_t. 

The difference is in the data that is used to train the statistical model that predicts the probability of being matched. If we allow for longer cycles and chains, the dependent  variable y should be a binary variable indicating whether or not that node was matched by an offline algorithm that also uses longer cycles and chains.

For the MAB method, in principle extension is similarly straightforward: include in the action space all k-cycles as well as the head of every chain, and apply Algorithms 3 and 4 to the expanded action space. In practice, computation constraints might kick in and it may be costly to explore the entire action space efficiently, so we are currently exploring different alternatives to reduce the size of this search by exploiting correlations between different actions.

[R1] How many cycles can MAB select per period?

Within one period, MAB keeps selecting and removing cycles until either there are no more cycles or -- more likely -- the average "pseudo-reward" of all available cycles dips below 0.5 (or other threshold). [Fig 4]


[R2] Overall lack of theory

We agree. This paper was mostly driven by "experiments" that we hope will serve as guidance for future theory. For example, one of this project's objectives was to examine what kind of statistics govern the performance of alternative algorithms, in particular when we are away from the steady state. In our MAB method, we observed that one such statistic is the average "pseudo-reward" (i.e., the probability of certain cycle *not* being used in future matchings). [End of 4.4; Figure 6] Now that we have confirmed that this is an object of great interest, we are studying how to compute it analytically in a simplified model with fewer types, but we feel that this discussion is best left for our next paper.


[R3] Do overdemanded and underdemanded pairs arrive at the same rate?

No: as in Unver (2010), we assume over-demanded pairs only enter when the donor is tissue-type incompatible with the patient. [Section 2.2]

[R3] Formulating the problem as a Markov decision process

Indeed, in an earlier iterations of this paper, we did model thep problem as a full-blown MDP and applied reinforcement learning methods to produce a workable solution. Unfortunately, even when using state-of-the-art techniques such as A3C (Mnih et al 2016) or double Q-learning (Van Hasselt 2016) we were unable to produce satisfactory results, likely due to our inability to find an efficient way to adequately represent the explosive state and action spaces. 

These disappointing results led us next to consider simpler solutions, and in fact that is how we ended up with the multi-armed bandit (MAB) method used in this paper (Note that "bandit" settings are a special case of MDPs, where neither the state or action spaces vary over time).

[R3] Comparison against other methods

Comparing our methods to Awasthi and Sandholm (2009) would have been in principle feasible, but we lacked the computational capacity to perform these comparisons. 

[R1-3] Typos and LaTeX blunders

We apologize for these mistakes pointed out by all reviewers, and will take an opportunity to revise the manuscript.





# Review 1

This paper looks at the kidney paired donation aka kidney exchange clearing problem.  Unlike most kidney exchange work, the authors consider a (i) dynamic environment where participants arrive and depart over time in (ii) a realistic/data-driven setting and (iii) non-myopic matching policies.  They propose two methods whose objectives are to maximize the average number of pairs matched per time period (as opposed to a static approach to this problem, where one is concerned with maximizing single-shot returns without considering future returns).  They propose two methods: one where a classifier is trained that predicts whether or not a participant will be matched at the next round, and the other based on MAB.  The MAB approach is novel and beats myopic matching in simulation.

This paper tackles an interesting and difficult dynamic optimization problem that hasn't been looked at in its full realism much.  To my knowledge, there has only been very limited work looking at (i), (ii), and (iii) together in kidney exchange:
* Awasthi and Sandholm, ICJAI-19
* Dickerson, Procaccia, and Sandholm, AAAI-12
* Dickerson and Sandholm, AAAI-15
* Khang, Harvard ~2016 or 2017
There has been recent excellent work with (i) and (iii), but not the realism of (ii), via, e.g.,:
* Akbarpour et al EC-14
* Ashlagi et al EC-13, EC-17, and arXiv-18
* Anderson et al EC-15 + Operations Research
And there has been recent work with (i) and (ii) but not the dynamic matching policies of (iii), via, e.g.,:
* Simulation results from Segev, Gentry, Roth, Ashlagi, Rees, and so on in American Journal of Transplantation 2011+
* Dickerson, Procaccia, and Sandholm EC-13 + Management Science
* Simulation results due to Kalbfleisch, Manlove, and others in bioinformatics and optimization venues
So, I appreciate that this work tackles what I see as a hole in the current literature.

Also, there's been some unsettled questions about whether or not dynamic policies can give any gain in the kidney exchange/dynamic matching settings, both on the theory (Akbarpour et al says yes, Ashlagi, Anderson et al says no) and practice side (Awasthi, Khang, Dickerson, Sandholm say yes), so this adds to that literature with a positive, albeit not a huge one.

Questions:
1)  The work only looks at a reduced form of kidney exchange involving pairwise swaps, that is, two-cycles.  The general framework would be applicable to the full problem, with k-cycles and longer chains, but it's unclear how the experimental results would translate to  longer elements, specifically longer chains.  For the classifier method, you could explode your X_t^k and E_t^k matrices by storing info about all types of cycles and chains (where "types" could be combos of ABO, cPRA, and so on), which is obviously enormous and probably not great.  Maybe do something with abstractions of types?  Deep learning, which you briefly mention in the future work section, has seen success in solving big-state-space problems like this via, among other things, automated abstraction discovery.  Could be a good improvement step that would take this work closer to real-world applicability.

2)  Binary preferences are considered.  In reality, exchanges associate with possible transplants a weight representing medical quality, fairness concerns, and so on.  I actually think edge-specific weights could be incorporated in ad hoc ways into both methods (e.g., weighting your coinflip in the classification method).  Any thoughts?

##### ??? ??? ??? ??? ??? ??? ???
> 3)  The OPTN environment pulls from living donation and doesn't have a notion of "pairedness", right?  That should at least be mentioned, because exchange data is going to have many more underdemanded pairs than overdemanded pairs due to compatibility between donors and patients.  This actually might increase the gap between MYOPIC and OPT for OPTN (Fig 2) due to further sparsifying the graph, so might increase the experimental gains your method sees.
##### ??? ??? ??? ??? ??? ??? ???

4)  What about the MDP/ADP literature?  This is solving a big MDP.  It'd be good to mention that, and say why it's tough (big state space, weird action space, and so on).

5)  Am I right in thinking that the MAB approach can select only one two-cycle per time period?  If so, what happens if we're e.g. the UK or Canada and we're matching every quarter, not multiple times per day?

6)  What about comparing against the current state of the art in this space, both Awasthi & Sandholm (and the papers they cite on ADP / MDP solving), or Dickerson & Sandholm?  Percentage-wise, it seems like you're getting roughly similar gains to their methods, but it's hard to compare across the different data generation frameworks.  Why is this approach better?



# Review 2

The authors study algorithms for conducting pairwise kidney exchange which, contrary to the extant literature, consider the future evolution of the patient-donor pool when deciding how to carry out the exchanges.

They propose two algorithms, one based on direct prediction and another based on multi-armed bandit methods. The first classifies a donor-patient pair as ‘match today’ or ‘match tomorrow’; the algorithm then finds a maximal matching amongst the nodes classified ‘match today’. The second tries to assess the costs and benefits of clearing out a certain cycle today; the idea is to avoid removing cycles involving pairs that can be used tomorrow for enhance matchings. They evaluate the performance of the algorithms via simulations. They find that direct prediction rarely outperforms a greedy algorithm that finds a maximal matching and carries it out without considering the characteristics of the pairs involved; while the multi-armed bandit method tends to outperform greedy.

The patient-donor pool is modeled as a graph where patient-donors arrive at a Poisson rate \lambda and when they arrive draw a death rate which determines their sojourn time. Preferences are binary: a match is either acceptable if compatible, or not if incompatible. They consider three simulation environments:

(i) the ABO environment compatibility between matches is only based on blood type; to allow for blood compatible pairs to participate, it is also assumed that they are incompatible with some probability.
(ii) the RSU environment draws pairs as the ABO environment, but also takes into account current waiting time, and cPRA when drawing edges to determine compatibilities. cPRA measures the compatibility of a patient with a random donor.
(iii) the OPTN environment uses data from the STAR dataset to determine how pairs are drawn. On top of the cPRA measure described, the authors also include a measure of cPRA that measures the compatibility of a donor with a random patient.

I liked the overall idea of the paper; it reminded me of the theoretical work by Anderson et al. and Akbarpour et al. being brought to bear on particular datasets. Both of these papers study the importance of taking into account the future when deciding which matches to carry out today. I also liked that they are able to evaluate the performance of the algorithms on graphs that are not the typical iid Erdos -Renyi graph since the way edges are drawn reflects better the intricacies that come with incorporating compatibilities.

However, I would have found a theoretical study of these algorithms more valuable than just comparing their performance based on simulations. It leaves the reader wondering whether the results would go through in ‘real life’.

For instance, there are two observations whose generality may be worth exploring. First, the observation that taking into account features about the future is specially relevant for sparse graphs seems like a point that could translate into a proof - i am not sure, however, whether this would require simplifying the environment substantially, which would be unfortunate. But I think it would be worth exploring. Second, it would also be useful to note how robust the observation that direct prediction does not do better than greedy is.

Finally, even when these algorithms perform better, how difficult are they to implement and how sensitive is their performance to the dataset on which they are trained or to the features of the environments left out?  These are also questions that could be explored theoretically, though I am not sure about the difficulty of doing so.

The authors should be warned that there are multiple typos and poor use of language throughout the text.

# Review 3

The authors study the problem of matching in a dynamic setting, which arises in the context of Kidney Exchange. Vertices represent incompatible patient-donor pairs, and they join a kidney exchange pool over time. Arrivals follow a Poisson distribution, and unmatched pairs are susceptible to depart according to a Geometric distribution.

Environments
They study three simulation environments, which incorporate an increasing level of complexity in terms of the compatibility structure of the underlying graph.
- The first environment (ABO) focuses on the blood types of patients and donors (pairs join the pool with a rate proportional to the fraction of the donor and patient blood types in the US population).
- The second environment (RSU) accounts for tissue-type incompatibilities between pairs, in addition to blood-type incompatibilities.
- The third environment (OPTN) works with real patient and donor data from the UNOS STAR dataset. By looking at the patient antibodies and the donor antigens, a probability of being compatible is computed for every two patient-donor pairs.

Remarks:
- In the ABO environment, it seems that the authors assume no correlation regarding the pair arrival probability. If I read correctly, the arrival of (A,O) is the same as that of an (O, A) pair. In practice, under-demanded pairs seem to accumulate in the pool, which would be susceptible to influence the choice of a good matching algorithm.
- It seems also that in all three models, the departure process is the same for all patients regardless of their types. This is understandable as a way to keep the number of parameters. In practice however, patient cPRA seems to influence the rate of departure (this could be because of competition between exchange programs, or because of varying levels of illness being correlated with cPRA). It would therefore be interestingto have an algorithm that accounts for discrepancies in departure rates in the matching process (and the decision of who to keep waiting).
- A common assumption is to normalize arrivals to 1 per time step, and adjust departures accordingly. Interestingly, the authors choose not to make this simplification, which leads to a new effect: a myopic optimization algorithm can perform well when arrivals are large and departures are large because the number of simultaneous arrivals is enough to generate some thickness in the graph.

Algorithms
The first algorithm considered, called “Direct Prediction”, is based on the idea that it may be good to make some vertices wait for a future match.
- The choice of these vertices relies on a relatively simple heuristic: do not consider in the matching the vertices that are unlikely to be matched at that time period by the offline algorithm.
- Because the offline solution is not readily available, a predictive model is trained on Monte Carlo simulations.
- The authors emphasize the difficulty of incorporating graph structure in the feature space.

The second algorithm, termed “Multi Armed Bandit”, is based on the idea that the future value of keeping vertices unmatched can be estimated through Monte Carlo simulations.
- At each time step, we wish to determine which match to conduct first. This is done by running a Multi Armed Bandit algorithm in the following way:
    - Each possible cycle represents an arm. When we select a cycle, two simulations are run assuming the cycle is either kept or removed from the graph.
    - If the two simulations return the same number of matches 1 is returned, otherwise 0 is returned. This means that the cycle with the highest average reward is most likely to not have much value in future matches.
- After a first cycle is determined, the algorithm chooses whether to match a second cycle or to stop and wait for new arrivals.

Results
- The Direct Prediction does not seem to perform well when compared to the Myopic algorithm. The authors suggest that this can be due to the prediction algorithm which have a low precision (too few vertices are predicted to matched).
- The MAB algorithm seems to perform well, but the authors only report results in the range d=0.05, 0.08, 0.1. This is also a range where Myopic performs particularly badly (because the departure rates are low, waiting may have a large value).

Remarks
- Could the problem of precision in Direct Prediction be solved by using a different loss function in the ML estimator?
- Based on results reported in Figure 10, it seems that the gap between MAB and Myopic is greater for OPTN than for RSU which itself is greater than for ABO. My hypothesis is that OPTN leads to a sparser graph than RSU, which itself is sparser than MAB, and that for sparse graphs, there is less value in optimization and more value in taking future arrivals into account. I feel that it would be interesting to understand better this tradeoff.
- Is there a reason for reporting results for d=0.5, 0.8, 1 in the DP case, and d=0.05, 0.08, 0.1 in the MAB case?

Overall Impression
I like this paper, it introduces two novel ideas to try and improve upon the Myopic algorithm in the context of kidney exchange. Two caveats though: first the results show significant variations in performance depending on the environment that is used. Having a better understanding of which of the underlying assumptions lead to these variations would be very useful. Second, an often used algorithm in practice consists of batching arrivals and running a optimization algorithm at fixed intervals. This seems a very natural benchmark that is likely to perform well when the departure rate is small (which is when Myopic may perform poorly).
I recommend weak acceptance.

Minor remarks and typos
- p8 “outside the scope”
- there are a number of undefined references throughout the paper (p7, p11, p13…)
- some of the figures seem noisy (e.g. white square in 8x6 of left plot in fig 2, 5x7 in middle row fig 10). Would more iterations make the plots cleaner?
