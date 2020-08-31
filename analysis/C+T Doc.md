## Clumping and Thresholding Windows by proxy

Sarah Urbut 08 31 2020

The C+T polygenic score is defined as the sum of allele
counts (genotypes), weighted by estimated effect sizes ob-
tained from genome-wide association studies, where two filtering steps have been applied (Wray et al. 2007; Purcell et al. 2009; Dudbridge 2013; Wray et al. 2014; Euesden et al. 2014;
Chatterjee et al. 2016).

More precisely, the variants are first clumped (C) so that only variants that
are weakly correlated with one another are retained. 

Clumping selects the most significant variant iteratively, computes correlation between this index variant and nearby variants within some genetic distance wc, and removes all the nearby variants that are correlated with this index variant beyond 2
a particular value r_{2}. 

Thresholding (T) consists in removing variants with a p-value larger than a chosen level of significance $(p > p_{T}$ . Both steps, clumping and thresholding, represent a statistical compromise between signal and noise. The clumping step prunes redundant correlated effects caused by linkage disequilibrium (LD) between variants. However, this procedure may also remove inde- pendently predictive variants in LD. Similarly, thresholding must balance between including truly predictive variants and reducing noise in the score by excluding null effects.

When applying C+T, one has three hyper-parameters to select, namely the squared correlation threshold $r_{2}$ and the
window size $w_{c}$ of clumping, along with the p value threshold $p_{T}$. Usually, C+T users assign default values for
clumping, such as $r_{c}$ of 0.1 (default of PRSice), 0.2 or 0.5
(default of PLINK), and $w_{c}$ of 250 kb (default of PRSice
filtering steps have been applied.

An example of this output is from PLINK below:

```
 CHR    F               SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2
   1    1    1:55500429:A:G   55500429          0        1      0      0      0      0      1 1:55502137:C:G(1)
   1    1    1:55513061:T:C   55513061          0        2      0      0      0      0      2 1:55511995:A:G(1),1:55516508:A:G(1)
   1    1    1:55522141:A:G   55522141          0        3      0      0      0      0      3 1:55518467:A:G(1),1:55521242:T:G(1),1:55557540:T:C(1)
   1    1    1:55526428:T:G   55526428          0        4      0      0      0      0      4 1:55543079:T:C(1),1:55552273:A:G(1),1:55605395:T:C(1),1:55638546:T:C(1)
```
where the column labeled SNP represents the index SNP that is both $\leq r_{c}$ and chosen to satisfy the index $lfsr$ threshold chose.

Plink proceeds with the following structure: There are four main parameters that determine the level of clumping, listed here in terms of the command flag used to change them and their default values:

       --clump-p1 0.0001          Significance threshold for index SNPs
     
       --clump-p2 0.01            Secondary significance threshold for clumped SNPs
 
       --clump-r2 0.50            LD threshold for clumping

       --clump-kb 250             Physical distance threshold for clumping
     
The clumping procedure takes all SNPs that are significant at threshold p1 (or lfsr in our case). that have not already been clumped (denoting these as index SNPs) and forms clumps of all other SNPs that are within a certain kb distance from the index SNP (default 250kb) and that are in linkage disequilibrium with the index SNP, based on an r-squared threshold (default 0.50). These SNPs are then subsetted based on the result for that SNP, as illustrated in the SP2 column above. 


## Practical Application

In our application, we filter in two additional ways:

#1 Only those variants that exist both in MVP and in 1000 genomes (1kg) are retained for clumping and thresholding
#2 Only the independent `index` snp is used for potential scoring.

The potential loss of useful infomration thus occurs in two steps, as we choose only SNPs that are genotyped and present in all 650K 'proportional individuals and the MVP individuals

#1 In limiting our index variants to only those that first satisfy the index variant lfsr threshold p1 above, we reduce the possible LD blocks identified.

#2 We risk losing the strongest signal in the window if it is not captured by  both MVP and 1kg.





## Proposal

In order to use the genotype information from 1kg but also the depth of our MVP coverage, I propose a two fold thresholding step, $t_{0}$.

#1 First, using the 1kg data, `clump` with a relaxed lfsr threshold $t_{0}$ of, suppose 0.5, or even 0.7. The goal here is not to capture true index SNPs, but really to define independent LD blocks, for which we will later threshold MVP (and not 1kg variants). Perform the usual steps of removing all variants within some distance $w_{c}$ that exceed an $r^{2}$ threshold. It is not necessary to retain the `clumped` SNPs (column p2) so to ease the computational burden p2 in this case can be very low (i.e. 1e-7).

#2 After defending these soft-index SNPS, define a new window A' and B' with boundaries 250 kb from soft index SNP. Choose the minimum MVP SNP in this window such that it satisfies the true lfsr threshold we are interested in. This can be significantly stringent, but ideally given the depth of coverage in MVP, we will identify both more independent signals and estimates that are stronger in magnitude in precision.

#References

Privé, Florian et al. The American Journal of Human Genetics, Volume 105, Issue 6, 1213 - 1221

Plink, Clumping Documentation, https://zzz.bwh.harvard.edu/plink/clump.shtml.
