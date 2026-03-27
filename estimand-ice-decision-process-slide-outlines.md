# Estimand ICE Strategy Debate: Bilingual Slide Outlines for Internal R&D

Prepared from the following source papers:

1. Fleming et al. (2025), *A Perspective on the Appropriate Implementation of ICH E9(R1) Addendum Strategies for Handling Intercurrent Events*
2. Morris et al. (2026), *A Causal Perspective on "Appropriate Implementation of ICH E9(R1) Addendum Strategies" (Comment on Fleming et al.)*
3. Keene et al. (2026), *Commentary on Fleming et al. "A Perspective on the Appropriate Implementation of ICH E9(R1) Addendum Strategies for Handling Intercurrent Events"*

This document is structured as four presentation options:

- English, compact deck (~10 slides)
- English, extended deck (~20 slides)
- Japanese, compact deck (~10 slides)
- Japanese, extended deck (~20 slides)

Each slide follows the user-specified format:

- [Slide Title]
- [Bullet Points]
- [Speaker Notes]

---

# 1) English Version - Compact Deck (~10 Slides)

## Slide 1
[Slide Title]  
Why this debate matters now

[Bullet Points]  
- Since ICH E9(R1), handling of intercurrent events (ICEs) is no longer a technical afterthought.  
- Choice of ICE strategy changes the estimand, not just the analysis method.  
- The same trial can support different causal questions depending on whether we use Treatment Policy, Hypothetical, Composite, Principal Stratum, or While-on-Treatment strategies.  
- R&D teams therefore need a disciplined decision process, not a default statistical habit.

[Speaker Notes]  
- The practical issue is not terminology; it is which treatment effect we are asking the trial to estimate.  
- Once the estimand changes, implications follow for control-arm design, follow-up expectations, data collection after discontinuation, missing-data assumptions, and ultimately the development claim.  
- The Fleming-Morris-Keene exchange matters because it exposes how easily teams can drift from the intended clinical question.

## Slide 2
[Slide Title]  
What changed after ICH E9(R1)

[Bullet Points]  
- ICH E9(R1) made ICE handling explicit within the estimand framework.  
- It encouraged transparency about the clinical question, not just transparency about missing-data methods.  
- In practice, this broadened the menu of acceptable-looking strategies.  
- That same flexibility also created room for "convenient" estimands that may not be clinically or causally robust.

[Speaker Notes]  
- The Addendum was a major advance because it forced teams to state how post-randomization events affect the treatment effect of interest.  
- But the framework itself does not guarantee good choices.  
- The current debate is, in essence, about how that flexibility should be governed in confirmatory drug development.

## Slide 3
[Slide Title]  
Fleming et al.: the central warning

[Bullet Points]  
- Fleming et al. argue that many protocols use Hypothetical, Principal Stratum, or While-on-Treatment strategies too casually in primary analyses.  
- Their concern is that these strategies often exclude or discount post-randomization information in ways that undermine comparability between randomized arms.  
- They also argue that such approaches can miss the intervention's meaningful net effect in real clinical care.  
- The main target of criticism is not sophistication per se, but scientifically fragile and clinically convenient analysis choices.

[Speaker Notes]  
- Fleming et al. are reacting to what they view as post-E9(R1) overreach.  
- Their most important accusation is that some analyses preserve the language of causal inference without preserving the protection offered by randomization.  
- They worry that sponsors may prefer estimands that make the experimental treatment look cleaner or stronger than the real treatment strategy actually is.

## Slide 4
[Slide Title]  
Fleming's proposed default: return to basics

[Bullet Points]  
- Use a standard-of-care control arm when possible.  
- Choose endpoints that measure how patients feel, function, or survive.  
- Follow all randomized participants despite discontinuation or rescue therapy.  
- For primary confirmatory inference, default to Treatment Policy, with Composite strategy for clinically compelling events such as death.

[Speaker Notes]  
- Fleming's preferred operating model is design discipline first, analysis discipline second.  
- If the trial is well designed, rescue is clinically sensible, and follow-up is complete, a Treatment Policy estimand can describe the effect of prescribing the regimen in realistic care conditions.  
- Their message is that good design reduces the need to rely on unverifiable counterfactual assumptions.

## Slide 5
[Slide Title]  
Morris et al.: do not solve a hard problem by asking an easier question

[Bullet Points]  
- Morris et al. reject a near-blanket preference for Treatment Policy.  
- They argue that rigorous causal inference requires clinical reasoning, causal reasoning, and statistical reasoning - not rules.  
- The estimand that is easiest to estimate is not always the estimand of greatest clinical value.  
- They also stress that criticisms should distinguish the estimand itself from a weak estimator used to target it.

[Speaker Notes]  
- This is a major conceptual rebuttal.  
- Morris et al. accept Fleming's frustration with sloppy implementation, but reject the jump from "bad implementations exist" to "the underlying estimand strategy is usually inappropriate."  
- Their concern is that teams may downgrade the clinical question merely to avoid methodological difficulty.

## Slide 6
[Slide Title]  
Morris et al.: Hypothetical can be valid when it is tangible

[Bullet Points]  
- Morris et al. propose "tangibility" as a practical screen: how would the hypothetical world be realized in future care?  
- When that question has a credible answer, Hypothetical estimands may be clinically meaningful.  
- They point to modern causal methods - g-methods, doubly robust approaches, instrumental-variable methods - as stronger options than naive censoring or simplistic MMRM assumptions.  
- Their historical AIDS examples show cases where simple ITT-style interpretation was clinically misleading.

[Speaker Notes]  
- Morris et al. are strongest in defending carefully justified Hypothetical estimands.  
- Their position is not that anything goes; it is that difficult questions sometimes deserve difficult methods.  
- The key condition is that the counterfactual world must be coherent, clinically relevant, and estimable under transparent assumptions.

## Slide 7
[Slide Title]  
Keene et al.: which causal effect do we actually want?

[Bullet Points]  
- Keene et al. emphasize that Treatment Policy estimates the effect of assignment, not necessarily the effect of receiving the intervention itself.  
- Alternative strategies can target different causal questions, including efficacy under adherence or in the absence of specific ICEs.  
- They argue that "preserving integrity of randomization" does not automatically make Treatment Policy uniquely correct.  
- In their view, all strategies require assumptions once missing data and post-ICE trajectories are considered.

[Speaker Notes]  
- Keene et al. sharpen the interpretational distinction between assignment effect and intervention effect.  
- This is especially relevant when patients discontinue, switch, or receive effective rescue therapy.  
- In such settings, a Treatment Policy estimand may reflect the total management pathway rather than the intervention's own efficacy profile.

## Slide 8
[Slide Title]  
Keene et al.: real-world relevance is not unique to Treatment Policy

[Bullet Points]  
- Trial-specific rescue patterns and post-discontinuation care may differ from future routine practice.  
- Therefore, Treatment Policy is not automatically the most generalizable estimand.  
- Hypothetical may sometimes better isolate the drug's efficacy, and Composite may sometimes appropriately count rescue or discontinuation as clinical failure.  
- Relevance depends on the decision context, not on a universal hierarchy of estimand strategies.

[Speaker Notes]  
- Keene et al. challenge the assumption that "uses all post-randomization data" automatically means "closest to real world."  
- If downstream care varies across geography, time, or market access, the future Treatment Policy may itself be unstable.  
- Their broader message is that real-world relevance is contextual and stakeholder-dependent.

## Slide 9
[Slide Title]  
What all three papers actually agree on

[Bullet Points]  
- Estimand selection should not be driven by convenience, optics, or mechanical convention.  
- Trial design and conduct matter as much as analysis.  
- Missing data prevention and post-ICE follow-up are critical.  
- Assumptions must be explicit, justified, and stress-tested with sensitivity analyses.

[Speaker Notes]  
- The surface disagreement is sharp, but the shared warning is stronger than it first appears.  
- None of the authors defend casual use of strong assumptions.  
- The real dispute is about how often alternative estimands should be primary, and what level of assumption burden is acceptable for confirmatory decision-making.

## Slide 10
[Slide Title]  
Our proposed healthy decision process

[Bullet Points]  
- Start with the decision to be supported: regulatory claim, clinical positioning, payer value, or mechanistic understanding.  
- For each ICE, ask whether it is part of treatment strategy, evidence of treatment failure, or an avoidable external disturbance.  
- Screen each candidate estimand for tangibility, preservation of interpretability, and assumption burden.  
- Use one primary estimand for the main decision, and supportive estimands for complementary questions.  
- Maintain a checklist specifically designed to avoid the "easy assumption" problem highlighted by Fleming.

[Speaker Notes]  
- Our practical recommendation is balanced: Treatment Policy or Composite should often be the starting point for confirmatory planning, but not the automatic destination.  
- If a Hypothetical or other non-TP estimand is central to the program, we should require explicit justification of clinical relevance, deliverability, identifiability, data availability, and sensitivity strategy.  
- The governance problem is not choosing one camp; it is preventing unjustified simplification.

---

# 2) English Version - Extended Deck (~20 Slides)

## Slide 1
[Slide Title]  
Purpose of this presentation

[Bullet Points]  
- Organize the academic debate on estimands and ICE strategies after ICH E9(R1).  
- Separate true scientific disagreements from rhetorical overstatement.  
- Translate the debate into a practical decision process for internal R&D planning.  
- Focus on what this means for confirmatory development, not only for statistical theory.

[Speaker Notes]  
- The goal is not to declare a winner between Fleming and the commentators.  
- The goal is to help development teams make better estimand choices before protocol finalization.  
- We therefore move from literature summary to operational decision framework.

## Slide 2
[Slide Title]  
Why R&D should care now

[Bullet Points]  
- Estimand choice affects protocol design, endpoint definition, data collection, SAP, and regulatory messaging.  
- Misalignment discovered late is expensive and hard to repair.  
- ICE strategy choices are increasingly visible to regulators and external reviewers.  
- Poor choices can either overstate efficacy or ask a less useful clinical question.

[Speaker Notes]  
- This is not a narrow biostatistics issue.  
- Clinical, regulatory, medical, and commercial teams all have stakes in what effect the trial is claiming.  
- The literature debate is useful because it highlights where internal cross-functional conversations often fail.

## Slide 3
[Slide Title]  
ICH E9(R1) refresher

[Bullet Points]  
- The Addendum requires explicit definition of the treatment effect of interest.  
- ICE handling is part of the estimand, not merely a downstream missing-data choice.  
- Core estimand attributes include population, endpoint, ICE strategy, and summary measure.  
- The intent was to improve transparency between scientific question and estimator.

[Speaker Notes]  
- ICH E9(R1) did not say one strategy is always best.  
- Instead, it gave a language for describing different questions more precisely.  
- The current dispute is about how that language should be used in confirmatory practice.

## Slide 4
[Slide Title]  
The post-E9(R1) menu of ICE strategies

[Bullet Points]  
- Treatment Policy: include post-ICE outcomes in the target effect.  
- Hypothetical: target the effect in a world where a specified ICE would not occur.  
- Composite: redefine the endpoint so the ICE becomes part of the outcome.  
- Principal Stratum / While-on-Treatment: condition on post-randomization states or time windows in specific ways.

[Speaker Notes]  
- Each strategy answers a different question.  
- The key mistake in practice is to treat these as interchangeable technical options.  
- Once the ICE strategy changes, the estimand changes, and so does the meaning of the result.

## Slide 5
[Slide Title]  
Why controversy intensified in practice

[Bullet Points]  
- The new framework made multiple strategies look legitimate on paper.  
- Some protocols appear to have reverse-engineered the estimand from a preferred analysis result.  
- Sponsors and reviewers now debate not only estimation, but also which question is worth asking.  
- The debate shifted from "how to handle missing data" to "what effect should be estimated at all?"

[Speaker Notes]  
- Fleming et al. are responding to what they see as this drift in practice.  
- The commentators accept the drift problem, but argue that Fleming's solution is too restrictive.  
- This helps explain why the exchange became unusually sharp for a methodological discussion.

## Slide 6
[Slide Title]  
Fleming et al.: thesis in one sentence

[Bullet Points]  
- For primary confirmatory analyses, Treatment Policy - sometimes combined with Composite for clinically compelling events - should usually be preferred because it best preserves randomization and captures meaningful net effects.  
- Hypothetical, Principal Stratum, and While-on-Treatment strategies are often misused and can be misleading.

[Speaker Notes]  
- This is the anchor of Fleming's position.  
- Their critique is strongest when these alternative strategies are used as the main basis for causal claims in registrational settings.  
- They allow some exceptions, but want those exceptions to remain rare and explicitly justified.

## Slide 7
[Slide Title]  
Fleming on integrity of randomization

[Bullet Points]  
- Randomization is the main protection against confounding in RCTs.  
- Analyses that use post-randomization information to exclude data can reintroduce non-comparability between arms.  
- Treatment Policy, in Fleming's view, best preserves the "as randomized" comparison.  
- This reduces reliance on strong and unverifiable assumptions.

[Speaker Notes]  
- Their core concern is not simply missing data volume.  
- It is that censoring, conditioning, or subgrouping based on post-randomization events may convert a randomized comparison into something closer to an observational comparison.  
- For Fleming, this is why the burden of proof should be high for non-TP primary estimands.

## Slide 8
[Slide Title]  
Fleming on meaningful net treatment effect

[Bullet Points]  
- Clinicians and patients care about the effect of prescribing a regimen in realistic care conditions.  
- Outcomes after discontinuation or rescue may still reflect treatment-related benefits or harms.  
- While-on-Treatment may miss carryover effects, delayed harms, or treatment-induced discontinuation patterns.  
- Hypothetical "no rescue" worlds may be clinically irrelevant when rescue is ethically necessary.

[Speaker Notes]  
- Fleming's argument is not only causal but also clinical.  
- The concern is that alternative strategies can answer a narrow or artificial question that fails to reflect the overall consequences of starting treatment.  
- Their examples include EXSCEL, oncology cross-over concerns, and settings with rescue medication.

## Slide 9
[Slide Title]  
Fleming on design discipline

[Bullet Points]  
- Use standard-of-care control arms whenever possible.  
- Choose endpoints that directly reflect how patients feel, function, or survive.  
- Continue follow-up after treatment discontinuation or rescue use.  
- Prevent missing data through protocol and consent design, rather than relying on heroic modeling later.

[Speaker Notes]  
- This is a major practical lesson from Fleming.  
- Their philosophy is that many estimand problems begin as design problems.  
- If the control arm is artificial, rescue is ad hoc, or follow-up stops after discontinuation, no elegant analysis can fully rescue interpretability.

## Slide 10
[Slide Title]  
Fleming on exceptions and Composite strategy

[Bullet Points]  
- Composite may be appropriate when the ICE itself is clinically compelling, such as death.  
- Composite can support ITT-style analysis while preserving clinical meaning.  
- Fleming is skeptical about treating discontinuation itself as a composite failure component.  
- Rare Hypothetical exceptions may exist when the excluded period is independent of treatment effect and treatment knowledge, such as war or pandemic disruption.

[Speaker Notes]  
- This slide matters because Fleming is often caricatured as allowing only Treatment Policy.  
- In fact, they explicitly allow Composite for major clinically relevant events and limited Hypothetical exceptions for external disruptions.  
- Their threshold is simply much higher than that of many applied trial teams.

## Slide 11
[Slide Title]  
Morris et al.: thesis in one sentence

[Bullet Points]  
- Rigorous causal inference requires a case-by-case chain of clinical, causal, and statistical reasoning; Treatment Policy should not become a one-size-fits-all rule.

[Speaker Notes]  
- Morris et al. agree that sloppy analyses are a problem.  
- Their disagreement is with the normative response.  
- They argue that forbidding difficult estimands is not the right way to improve rigor.

## Slide 12
[Slide Title]  
Morris framework: from question to estimate

[Bullet Points]  
- Clinical reasoning defines the real decision problem.  
- Causal reasoning defines the estimand and identification assumptions.  
- Statistical reasoning chooses an estimator consistent with those assumptions.  
- The process is iterative, not linear, and may require returning to design choices.

[Speaker Notes]  
- Morris et al. visualize this as a pathway, not a rulebook.  
- This matters because the same clinical question can admit different identification strategies, and the same estimator can be appropriate or inappropriate depending on the estimand.  
- Their framework also encourages early dialogue between clinicians and statisticians.

## Slide 13
[Slide Title]  
Morris critique: easiest to estimate is not always most meaningful

[Bullet Points]  
- Treatment Policy and Composite may sometimes be simpler to estimate, but not necessarily most relevant.  
- Fleming's paper, in Morris's view, sometimes critiques weak estimation methods rather than the estimands themselves.  
- Bias is a property of an estimator for a given estimand, not a label to attach loosely to an estimand strategy.  
- Treatment Policy under missing data also creates major estimation challenges.

[Speaker Notes]  
- This is an important methodological correction.  
- Morris et al. want us to separate three layers: the question, the identification argument, and the estimation procedure.  
- Their warning is that teams may confuse "hard to estimate well" with "not worth asking."

## Slide 14
[Slide Title]  
Morris tangibility criterion

[Bullet Points]  
- Ask how the claimed benefit would actually be delivered in future care.  
- For Hypothetical: how would the ICE be prevented in practice?  
- For Principal Stratum: how would the relevant stratum be identified before treatment?  
- For Treatment Policy: will post-randomization care patterns and ICE rates remain stable outside the trial?

[Speaker Notes]  
- Tangibility is Morris's most practically useful contribution.  
- It forces the discussion back to implementation rather than abstract rhetoric.  
- It also shows that Treatment Policy should not get a free pass; it too can become untethered from future practice.

## Slide 15
[Slide Title]  
Morris on causal methods for Hypothetical estimands

[Bullet Points]  
- Modern methods include g-estimation, IPCW, doubly robust estimators, semiparametric approaches, and IV-based methods.  
- These methods can use time-varying covariates and post-baseline clinical trajectories.  
- They are often stronger than naive censoring, naive MMRM, or simple proportional hazards modeling after ICEs.  
- Assumptions remain necessary, but the solution is better causal reasoning, not avoidance of the question.

[Speaker Notes]  
- Morris et al. are not claiming these methods remove assumptions.  
- They are claiming the assumptions can be better aligned with the clinical question than those underlying simplistic implementation choices.  
- This is why their tone is more optimistic about carefully targeted Hypothetical estimands.

## Slide 16
[Slide Title]  
Morris historical examples: why ITT was not always enough

[Bullet Points]  
- In AIDS Trial ACTG 002, differential prophylaxis use complicated simple ITT interpretation.  
- In ACTG 021, noncompliance and switching obscured the clinically relevant contrast.  
- Robins's causal methods targeted questions closer to the effect of interest for future care.  
- Morris uses these examples to show that hard clinical questions sometimes require harder methods.

[Speaker Notes]  
- The historical argument is strategically important.  
- Morris is effectively saying: had we followed a rigid Treatment Policy-only philosophy in those settings, we would have learned less from important trials.  
- This is meant as a rebuttal to Fleming's implicit conservatism.

## Slide 17
[Slide Title]  
Keene et al.: thesis in one sentence

[Bullet Points]  
- Treatment Policy is not the only strategy that supports causal reasoning; what matters is matching the estimand to the scientific question and recognizing the distinction between assignment effect and intervention effect.

[Speaker Notes]  
- Keene et al. share Morris's pluralistic orientation, but sharpen the interpretational aspects.  
- Their commentary is especially useful for explaining why Treatment Policy may not answer the question many clinicians think it answers.  
- This becomes important when communicating results outside statistics.

## Slide 18
[Slide Title]  
Keene on estimation burden and interpretation

[Bullet Points]  
- Treatment Policy attributes post-discontinuation or rescue-mediated outcomes to initial assignment.  
- Missing data still create strong, often unverifiable assumptions under Treatment Policy.  
- Continuous Composite estimands require explicit and influential failure-value choices.  
- Primary analyses should include all randomized participants, but the included data should still align with the clinical question.

[Speaker Notes]  
- Keene's point is that Treatment Policy is not assumption-free, only different in where assumptions sit.  
- They also remind us that Composite is not a neutral escape hatch; failure-value calibration can materially affect variance and interpretation.  
- This helps keep the debate balanced.

## Slide 19
[Slide Title]  
Keene on real-world relevance and plural scientific questions

[Bullet Points]  
- The future care pathway after an ICE may differ from the trial setting.  
- Therefore, Treatment Policy is not automatically the most generalizable estimand.  
- Hypothetical may better isolate the drug's efficacy profile in some settings; Composite may reasonably count rescue or discontinuation as clinically relevant failure.  
- Regulators, prescribers, payers, and patients may each prioritize different causal questions.

[Speaker Notes]  
- Keene pushes back against the idea of a single universally preferred primary question.  
- Their argument is especially important in non-inferiority, adherence-sensitive settings, and therapeutic areas where rescue therapy is itself a meaningful failure signal.  
- The implication is not to multiply estimands indiscriminately, but to be explicit about whose decision each estimand informs.

## Slide 20
[Slide Title]  
Our synthesis: a healthy decision process for development programs

[Bullet Points]  
- Both sides are warning against easy, weakly justified choices.  
- Treatment Policy or Composite should usually be the starting point for confirmatory planning, but not a dogma.  
- Non-TP strategies should be allowed only when the clinical question is genuinely important, the target world is tangible, and the identifying assumptions are explicit and defensible.  
- We should pre-specify one main decision-driving estimand, complementary supportive estimands, and a sensitivity strategy.  
- A formal internal checklist should be used to avoid "convenient analysis" masquerading as scientific rigor.

[Speaker Notes]  
- This is the practical conclusion for R&D.  
- The deepest shared message across the papers is not "always use Treatment Policy" or "always use more advanced causal methods."  
- It is: never let convenience decide the question, never hide the assumptions, and never wait until the SAP to resolve what decision the trial is meant to support.

---

# 3) Japanese Version - Compact Deck (~10 Slides)

## Slide 1
[Slide Title]  
なぜ今この論争が重要か

[Bullet Points]  
- ICH E9(R1)以降、ICE(intercurrent event)の扱いは単なる解析上の補足事項ではなくなった。  
- ICE戦略の選択は、解析法ではなくEstimandそのものを変える。  
- 同じ試験データでも、Treatment Policy、Hypothetical、Composite、Principal Stratum、While-on-Treatmentで問う効果は異なる。  
- したがって、R&Dでは統計的な慣習ではなく、意思決定に根差した選択プロセスが必要である。

[Speaker Notes]  
- 本論点は用語整理ではなく、「この試験で何の治療効果を主張するのか」という開発戦略の問題である。  
- Estimandが変われば、対照群設計、追跡方針、ICE後データ収集、欠測仮定、規制当局への説明まで連動して変わる。  
- 今回の3論文は、その選択がいかに安易になり得るかを示している。

## Slide 2
[Slide Title]  
ICH E9(R1)後に何が変わったか

[Bullet Points]  
- ICH E9(R1)は、ICEの扱いをEstimand定義の中に明示的に組み込んだ。  
- 目的は、欠測処理の透明化だけでなく、臨床的問いの透明化であった。  
- その結果、見かけ上は複数の戦略が同等に選べるようになった。  
- 一方で、その柔軟性が「都合のよいEstimand」を正当化する余地も生んだ。

[Speaker Notes]  
- Addendum自体は大きな進歩である。  
- ただし、枠組みが与えられたことと、よい選択がなされることは別問題である。  
- 現在の論争は、この自由度を確証的開発でどう統治すべきか、という点にある。

## Slide 3
[Slide Title]  
Fleming et al. の中心的な警鐘

[Bullet Points]  
- Flemingらは、多くのプロトコルでHypothetical、Principal Stratum、While-on-Treatmentが主要解析に安易に使われていると批判する。  
- それらは、ランダム化後情報を用いて比較可能性を損ない得る。  
- さらに、実臨床で重要な「介入の正味の効果」を捉え損なう可能性がある。  
- 批判対象は高度手法そのものではなく、科学的に脆弱で都合のよい解析選択である。

[Speaker Notes]  
- Flemingらの問題意識は、E9(R1)以後に生じた実務上の逸脱に向けられている。  
- 彼らの最も強い懸念は、因果推論の言葉を用いながら、実際にはランダム化の保護を失っているケースである。  
- すなわち、「見栄えのよい推定対象」を主要解析に据えることへの警鐘である。

## Slide 4
[Slide Title]  
FlemingがTreatment Policyを基本線とする理由

[Bullet Points]  
- 可能なら標準治療対照を用いる。  
- 主要評価項目は患者のfeels/functions/survivesに直結させる。  
- 中止やレスキュー後も全例を追跡する。  
- 主要な確証的推論ではTreatment Policyを基本とし、死亡等の重要事象はCompositeで扱う。

[Speaker Notes]  
- Flemingの立場は、「まず設計を正し、次に解析を正す」という考え方である。  
- 試験が適切に設計され、追跡が保たれていれば、Treatment Policyは実臨床に近いレジメン効果を記述しやすい。  
- つまり、反事実に強く依存する前に、設計で問題を減らすべきだという主張である。

## Slide 5
[Slide Title]  
Morris et al. の反論: 難しい問いを易しい問いに置き換えるな

[Bullet Points]  
- Morrisらは、Treatment Policyへの一律の傾斜に反対する。  
- 厳密な因果推論には、臨床推論、因果推論、統計推論の連鎖が必要である。  
- 推定しやすいEstimandが、最も臨床的価値の高いEstimandとは限らない。  
- また、Estimand自体への批判と、その推定法への批判は分けるべきだとする。

[Speaker Notes]  
- Morrisらは、Flemingの「雑な実装」批判には一定程度同意している。  
- ただし、そこから「だからTreatment Policyをほぼ常に選ぶべき」とはならない、というのが反論の核心である。  
- 臨床的に重要な問いを、方法論的な都合で下げてはならないという立場である。

## Slide 6
[Slide Title]  
Morris et al. の反論: 実装可能なHypotheticalなら高度手法で扱える

[Bullet Points]  
- Morrisらは、Hypotheticalを評価する実務基準として "tangibility" を提案する。  
- 将来の診療でその仮想世界をどう実現するか説明できるなら、Hypotheticalは臨床的に意味を持ち得る。  
- g-methods、doubly robust法、IV法など、単純な打ち切りより強い因果推論手法が存在する。  
- AIDS試験の歴史的事例では、単純なITT解釈が臨床的に不十分であった。

[Speaker Notes]  
- Morrisらが最も強く擁護しているのは、慎重に定義されたHypotheticalである。  
- 彼らの主張は「何でも許される」ではなく、「重要な問いには適切に高度な方法を用いるべき」というもの。  
- 条件は、仮想世界が臨床的に整合的で、かつ仮定を明示できることである。

## Slide 7
[Slide Title]  
Keene et al. の反論: 求めるのは割付効果か、介入効果か

[Bullet Points]  
- Keeneらは、Treatment Policyが評価するのは主として割付効果であり、介入そのものの効果とは限らないと指摘する。  
- 他の戦略は、遵守下の効果や特定のICEが起きない場合の効果など、別の因果的問いを扱いうる。  
- "randomizationの整合性" を保つことが、直ちにTreatment Policyの一択を意味するわけではない。  
- 欠測やICE後経路を考えれば、どの戦略でも仮定は必要である。

[Speaker Notes]  
- この指摘は、結果解釈の観点で重要である。  
- 中止やスイッチ、レスキューが多い試験では、Treatment Policyは「薬剤単独の効力」ではなく、その後の治療経路を含む総合効果になりやすい。  
- そのため、誰の意思決定を支える効果なのかを明確にする必要がある。

## Slide 8
[Slide Title]  
Keene et al. の反論: 実臨床関連性はTreatment Policyの専売特許ではない

[Bullet Points]  
- 試験内のレスキューや中止後治療が、将来の実臨床と一致するとは限らない。  
- したがって、Treatment Policyが常に最も一般化可能とは言えない。  
- Hypotheticalが薬剤本来の効力をより明確に示す場面もある。  
- Compositeも、レスキューや中止を臨床的失敗として扱う上で有用な場合がある。

[Speaker Notes]  
- Keeneらは、「全データを使うこと」と「実臨床に最も近いこと」を同一視しない。  
- 市場導入後の治療経路が試験時点と異なる場合、Treatment Policy自体が不安定になりうるからである。  
- 実臨床関連性は、戦略名ではなく、意思決定文脈との適合で決まる。

## Slide 9
[Slide Title]  
三者が実は共有していること

[Bullet Points]  
- Estimand選択を、利便性や見栄えで決めてはならない。  
- 試験デザインと試験実施は、解析と同じくらい重要である。  
- 欠測の予防とICE後データ取得は不可欠である。  
- 仮定は明示し、感度解析で頑健性を検証すべきである。

[Speaker Notes]  
- 表面的には対立が強いが、共通する警鐘はむしろ明確である。  
- 誰も「安易な強仮定」を擁護していない。  
- 実際の争点は、非Treatment PolicyのEstimandを主要解析としてどこまで許容するかである。

## Slide 10
[Slide Title]  
当社としての健全な意思決定プロセス

[Bullet Points]  
- まず、その試験が支えるべき意思決定を定義する。  
- 次に、各ICEが「治療戦略の一部」「治療失敗の徴候」「回避可能な外乱」のどれかを整理する。  
- 候補Estimandを、tangibility、解釈可能性、仮定負荷で評価する。  
- 主要Estimandは1つに絞り、補助Estimandで別の問いを補う。  
- Flemingが警告した "easy assumption" を避けるための社内チェックリストを必須化する。

[Speaker Notes]  
- 実務上の提案は中庸である。  
- 確証的計画ではTreatment PolicyまたはCompositeを出発点とするが、自動的な結論とはしない。  
- Hypothetical等を主要化する場合は、臨床的必要性、実装可能性、識別可能性、データ要件、感度解析計画を明示的に審査すべきである。

---

# 4) Japanese Version - Extended Deck (~20 Slides)

## Slide 1
[Slide Title]  
本発表の目的

[Bullet Points]  
- ICH E9(R1)後のEstimand/ICE戦略論争を整理する。  
- 学術的な対立点と、実務上の示唆を切り分ける。  
- R&Dの開発計画に使える意思決定プロセスへ落とし込む。  
- 統計理論の紹介ではなく、確証的開発での判断材料を提示する。

[Speaker Notes]  
- 本発表の目的は、Flemingか批判側かの勝敗を決めることではない。  
- 開発現場で、どのEstimandを主要な意思決定軸に置くべきかを整理することが主眼である。  
- そのため、文献要約に加えて、社内運用可能な判断枠組みを提示する。

## Slide 2
[Slide Title]  
なぜR&Dが今この論点を重視すべきか

[Bullet Points]  
- Estimandの選択は、プロトコル設計、主要評価項目、データ収集、SAP、規制メッセージに直結する。  
- 後工程での整合性修正は高コストである。  
- 規制当局や外部査読者は、ICE戦略の妥当性をより厳しく見るようになっている。  
- 不適切な選択は、効力を過大評価するか、逆に臨床的に価値の低い問いを採用する結果を招く。

[Speaker Notes]  
- これはBiostatisticsだけの論点ではない。  
- Clinical、Regulatory、Medical、Commercialの全てに影響する。  
- 3論文が示しているのは、部門横断で問いを揃えないまま解析法だけが先行する危険性である。

## Slide 3
[Slide Title]  
ICH E9(R1)の要点再確認

[Bullet Points]  
- Addendumは、治療効果の定義を明示的に行うことを求めた。  
- ICEの扱いは、欠測処理の後付けではなくEstimandの構成要素である。  
- 母集団、評価変数、ICE戦略、summary measureの整合が必要である。  
- 目的は、科学的問いと推定量の対応関係を透明化することであった。

[Speaker Notes]  
- ICH E9(R1)は、特定の戦略を一律に推奨したわけではない。  
- むしろ、異なる問いを明示的に区別するための共通言語を提供した。  
- 今回の論争は、その自由度を確証的試験でどう扱うべきかに関するものと理解できる。

## Slide 4
[Slide Title]  
ICE戦略の選択肢

[Bullet Points]  
- Treatment Policy: ICE後のアウトカムも含めて比較する。  
- Hypothetical: 特定のICEが起きない世界での効果を問う。  
- Composite: ICE自体を評価項目の一部に組み込む。  
- Principal Stratum / While-on-Treatment: ランダム化後状態や曝露期間に依存した効果を定義する。

[Speaker Notes]  
- 各戦略は別々の因果的問いを表す。  
- 実務上の誤りは、これらを単なる解析オプションとして扱うことである。  
- ICE戦略が変わると、試験が答える臨床的問いそのものが変わる。

## Slide 5
[Slide Title]  
なぜ実務上の論争が強まったのか

[Bullet Points]  
- Addendumにより、複数の戦略が形式上は正当化しやすくなった。  
- 一部のプロトコルでは、望ましい結果に合わせてEstimandが後付けで選ばれた疑いがある。  
- 議論の焦点が、欠測処理から「そもそも何を推定するのか」へ移った。  
- Flemingらは、この実務上の逸脱に対して強く反応している。

[Speaker Notes]  
- 重要なのは、論争の背景に現場での運用不全があることだ。  
- 批判側も、その運用不全自体は否定していない。  
- 対立点は、その是正策としてTreatment Policyをどこまで規範化すべきかにある。

## Slide 6
[Slide Title]  
Fleming et al. の主張を一言で言うと

[Bullet Points]  
- 主要な確証的解析では、Treatment Policyを基本とし、必要に応じてCompositeを用いるべきであり、Hypothetical、Principal Stratum、While-on-Treatmentの主要解析への安易な採用は危険である。

[Speaker Notes]  
- Flemingの主張はかなり明確である。  
- 彼らは、これら代替戦略が主要解析として用いられると、因果帰属と臨床解釈の双方が不安定になると考えている。  
- 例外は認めるが、その範囲は限定的である。

## Slide 7
[Slide Title]  
Fleming: randomizationの整合性

[Bullet Points]  
- RCTにおける交絡制御の基盤はrandomizationである。  
- ランダム化後情報を用いてデータを除外・制限すると、群間の比較可能性が損なわれる。  
- Flemingは、Treatment Policyが "as randomized" 比較を最も保ちやすいと考える。  
- その結果、検証不能な仮定への依存を減らせると主張する。

[Speaker Notes]  
- Flemingの核心は、欠測量の問題よりも "conditioning after randomization" の問題にある。  
- すなわち、打ち切りや事後サブグループ化によって、無作為化比較が観察研究に近づいてしまうことを恐れている。  
- これが、非TP戦略に高い立証責任を課す理由である。

## Slide 8
[Slide Title]  
Fleming: 臨床的に意味のある正味効果

[Bullet Points]  
- 処方者・患者が知りたいのは、実際の診療下でそのレジメンを開始したときの効果である。  
- 中止後やレスキュー後のアウトカムも、介入の利益・不利益を反映し得る。  
- While-on-Treatmentは、carry-over effect、遅発性有害性、治療起因の中止パターンを見落とし得る。  
- 倫理的に必要な救済治療がある状況で "no rescue" のHypotheticalを主要化することには疑義がある。

[Speaker Notes]  
- Flemingは、因果推論だけでなく臨床関連性の観点からも批判している。  
- 実験治療開始の総合的帰結を問うべきで、人工的な反事実を主要な結論にすべきではないという立場である。  
- EXSCELやオンコロジーのクロスオーバー例は、その問題意識を示す。

## Slide 9
[Slide Title]  
Fleming: 設計規律の重視

[Bullet Points]  
- 可能なら標準治療対照を採用する。  
- 主要評価項目はfeels/functions/survivesに直結させる。  
- 中止と試験離脱を明確に区別し、ICE後も追跡する。  
- 欠測はモデリングで救う前に、設計と運用で予防すべきである。

[Speaker Notes]  
- Flemingの示唆は、解析論よりもむしろデザイン論として有用である。  
- 対照群が不自然、レスキューが場当たり的、追跡が切れる、という設計では、後からどれだけ洗練された推定法を当てても限界が残る。  
- この点は、批判側も概ね共有している。

## Slide 10
[Slide Title]  
Fleming: 例外とCompositeの位置づけ

[Bullet Points]  
- 死亡など臨床的に強い意味を持つICEはCompositeで扱う余地がある。  
- CompositeによりITT的解析と臨床的意味づけを両立しやすくなる。  
- 一方、単なる治療中止をComposite failureに入れることには慎重である。  
- 戦争やパンデミックなど、介入効果と独立した外乱には限定的にHypotheticalを認める。

[Speaker Notes]  
- Flemingは "Treatment Policy only" を主張しているわけではない。  
- 重要なのは、CompositeやHypotheticalを認めるハードルが高いことである。  
- 例外は、臨床的必要性と仮定の妥当性が明確な場合に限定される。

## Slide 11
[Slide Title]  
Morris et al. の主張を一言で言うと

[Bullet Points]  
- 厳密な因果推論は、臨床・因果・統計の推論連鎖に基づくべきであり、Treatment Policyを汎用ルール化すべきではない。

[Speaker Notes]  
- Morrisらは、雑な解析を擁護しているのではない。  
- むしろ、安易なルール化によって重要な臨床的問いが切り捨てられることを危惧している。  
- ここがFlemingとの最も大きな思想的相違点である。

## Slide 12
[Slide Title]  
Morris: 問いから推定値までの経路

[Bullet Points]  
- Clinical reasoningが意思決定上の問いを定義する。  
- Causal reasoningがEstimandと識別仮定を定める。  
- Statistical reasoningが推定量を選ぶ。  
- この過程は反復的であり、必要に応じて設計に立ち返る。

[Speaker Notes]  
- Morrisらの図式の価値は、Estimand選択を単独の統計判断にしない点にある。  
- 臨床文脈と識別可能性を先に問い、その後で推定法を選ぶ。  
- この順序は、社内のcross-functional alignmentにも有用である。

## Slide 13
[Slide Title]  
Morris: 「推定しやすさ」と「意味の深さ」は別問題

[Bullet Points]  
- Treatment PolicyやCompositeは、しばしば推定しやすい。  
- しかし、それが最も重要な臨床的問いとは限らない。  
- Flemingの批判は、しばしばEstimandそのものより、弱い実装法への批判になっているとMorrisは指摘する。  
- さらに、Treatment Policyも欠測があれば推定は容易ではない。

[Speaker Notes]  
- Morrisが強調するのは、EstimandとEstimatorの分離である。  
- ある戦略が "biased" かどうかは、推定法と仮定次第であり、戦略名だけでは決まらない。  
- これは、議論を整理する上で重要な概念上の修正である。

## Slide 14
[Slide Title]  
Morris: tangibilityという実務基準

[Bullet Points]  
- その効果は将来の診療でどう実現されるのか、を問う。  
- Hypotheticalなら、ICEをどう防ぐのか。  
- Principal Stratumなら、対象層を治療前にどう同定するのか。  
- Treatment Policyでも、試験内のICE分布が将来も維持されるかを問う必要がある。

[Speaker Notes]  
- tangibilityは、実務上もっとも有用な概念の一つである。  
- 抽象的な "real-world relevance" を、具体的な実装可能性へ引き戻すからである。  
- また、Treatment Policyにも無条件の優位を与えない点が重要である。

## Slide 15
[Slide Title]  
Morris: Hypotheticalを支える因果推論手法

[Bullet Points]  
- g-estimation、IPCW、doubly robust estimator、semiparametric法、IV法などがある。  
- これらはtime-varying covariateやpost-baseline trajectoryを取り込める。  
- 単純な打ち切りやMMRM仮定より、臨床的問いに整合する場合がある。  
- 重要なのは、仮定を減らすことではなく、問いに合った仮定を明示することである。

[Speaker Notes]  
- Morrisらは、仮定不要とは言っていない。  
- ただし、単純化された実装よりも、因果構造に整合した仮定を置く方が科学的に誠実だと考えている。  
- その意味で、問題は "Hypotheticalか否か" ではなく、識別戦略の質にある。

## Slide 16
[Slide Title]  
Morris: AIDS試験の歴史的事例

[Bullet Points]  
- ACTG 002では、予防投与の群間差が単純ITT解釈を難しくした。  
- ACTG 021では、非遵守やスイッチが臨床的に重要な比較を覆い隠した。  
- Robinsの手法は、将来診療に近い問いを明確化したとMorrisは評価する。  
- すなわち、難しい臨床的問いには難しい方法が必要になり得る。

[Speaker Notes]  
- Morrisの歴史的論拠は、Treatment Policy一辺倒への反証として機能している。  
- 過去の重要試験でも、単純なITTだけでは不十分な場面があったという指摘である。  
- これは、因果推論手法を確証的試験から排除すべきでないという主張につながる。

## Slide 17
[Slide Title]  
Keene et al. の主張を一言で言うと

[Bullet Points]  
- Treatment Policyだけが因果的に正しいわけではなく、割付効果と介入効果を区別した上で、科学的問いに合うEstimandを選ぶべきである。

[Speaker Notes]  
- KeeneらはMorrisと同じく多元的立場だが、特に解釈上の違いを鋭く示している。  
- Treatment Policyが何を意味し、何を意味しないのかを明示する点で、社内説明にも有用である。  
- とくに非遵守やレスキューの多い試験で重要になる。

## Slide 18
[Slide Title]  
Keene: 推定負荷と解釈上の注意

[Bullet Points]  
- Treatment Policyは、中止後やレスキュー後の経路を含めた割付効果を評価する。  
- 欠測があれば、Treatment Policyでも強い仮定が必要になる。  
- 連続量のCompositeでは、failure valueの設定が推定結果に影響し得る。  
- 全ランダム化例を含めることと、全てのpost-ICEデータを主要解析に使うことは同義ではない。

[Speaker Notes]  
- Keeneのポイントは、Treatment Policyを "easy" と見なすべきでないという点である。  
- 仮定の置き場所が違うだけで、仮定自体は残る。  
- また、Compositeも万能ではなく、定義次第で解釈と分散に影響する。

## Slide 19
[Slide Title]  
Keene: 実臨床関連性と複数の科学的問い

[Bullet Points]  
- 将来の実臨床におけるICE後治療経路は、試験時と一致しない可能性がある。  
- そのため、Treatment Policyが常に最も一般化可能とは限らない。  
- Hypotheticalが薬剤本来のefficacy profileをより明確に示すこともある。  
- 規制当局、処方者、患者、payerでは、優先する問いが異なり得る。

[Speaker Notes]  
- Keeneは、「主要な科学的問いは常に一つ」という見方に慎重である。  
- ただし、Estimandを無秩序に増やすべきだと言っているわけではない。  
- 重要なのは、各Estimandが誰のどの判断を支えるのかを明示することである。

## Slide 20
[Slide Title]  
総合提言: 健全な意思決定プロセスをどう組み込むか

[Bullet Points]  
- 両陣営に共通するのは、「安易で根拠の薄い選択」を避けよという警告である。  
- 確証的計画では、Treatment PolicyまたはCompositeを出発点とする。  
- ただし、非TP戦略が真に重要な問いを支えるなら、tangibility、識別仮定、データ要件、感度解析を明示して採用する。  
- 主要Estimandと補助Estimandを明確に分ける。  
- 社内では、Convenience-drivenなEstimand選択を防ぐチェックリストとreview会議を制度化する。

[Speaker Notes]  
- 実務上の結論は、どちらか一方への全面的追随ではない。  
- Flemingの懸念を真摯に受け止めつつ、Morris・Keeneが示した方法論的選択肢も閉ざさないことが重要である。  
- つまり、「まず問いを定義し、次に設計し、その後に推定する」という順序を守るガバナンスが必要である。

---

# Optional Internal Appendix: Fleming Concern Avoidance Checklist

This appendix is not part of the slide count, but can be converted into a backup slide or a one-page handout.

1. **Decision clarity**  
   - What exact decision will the estimand support?  
   - Who is the primary decision-maker: regulator, clinician, payer, patient, or internal portfolio team?

2. **ICE mapping**  
   - Which ICEs are expected?  
   - For each ICE, is it part of the treatment strategy, evidence of failure, or an external disturbance?

3. **Tangibility / deliverability**  
   - If Hypothetical is proposed, how would that no-ICE world be realized in future care?  
   - If Principal Stratum is proposed, how would the target stratum be identified prospectively?

4. **Randomization and identification**  
   - Does the proposal condition on post-randomization variables in a way that threatens comparability?  
   - What assumptions are required for identification? Are they clinically credible?

5. **Data sufficiency**  
   - Will post-ICE data be collected for all relevant participants?  
   - Are time-varying covariates available if advanced causal methods are needed?

6. **Sensitivity strategy**  
   - Are missing-data assumptions and causal assumptions stress-tested?  
   - Is there a pre-specified tipping-point or alternative-model strategy?

7. **Governance**  
   - Has the estimand been challenged by cross-functional review?  
   - Could an external reviewer reasonably accuse us of choosing the estimand for convenience?

---

# 社内補遺（日本語）: Flemingの懸念を回避するためのチェックリスト

この補遺はスライド枚数には含めないが、バックアップスライドまたは1枚もののハンドアウトとして利用できる。

1. **意思決定の明確化**  
   - このEstimandは、どの意思決定を支えるのか。  
   - 主たる意思決定者は誰か。規制当局、臨床医、payer、患者、社内ポートフォリオのいずれか。

2. **ICEの棚卸し**  
   - 想定されるICEは何か。  
   - 各ICEは、治療戦略の一部か、治療失敗の証拠か、外的撹乱か。

3. **Tangibility / 実装可能性**  
   - Hypotheticalを採るなら、その「ICEが起きない世界」を将来診療でどう実現するのか。  
   - Principal Stratumを採るなら、対象層を治療前にどう同定するのか。

4. **Randomizationと識別**  
   - 提案した解析は、ランダム化後変数への条件付けによって群間比較可能性を損なっていないか。  
   - 識別に必要な仮定は何か。それは臨床的に妥当か。

5. **データ十分性**  
   - 必要な対象についてICE後データを収集できる設計か。  
   - 高度な因果推論手法が必要な場合、time-varying covariateは利用可能か。

6. **感度解析戦略**  
   - 欠測仮定と因果仮定は十分にstress-testされているか。  
   - tipping-point解析や代替モデルによる事前規定があるか。

7. **ガバナンス**  
   - このEstimandはcross-functional reviewで実質的に検証されたか。  
   - 外部査読者から「都合の良いEstimand選択」と見なされる余地はないか。
