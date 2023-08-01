# Overview
This project utilises clustering algorithms to categorise countries based on key socio-economic and health metrics. The goal was to identify and prioritise countries in dire need of funds for maximum impact. The dataset used was from [kaggle](https://www.kaggle.com/datasets/rohan0301/unsupervised-learning-on-country-data).

## Dependencies
- **Matlab 2020a**: Main software for data processing and clustering.
- **Plot2LaTeX**: [Script](https://www.mathworks.com/matlabcentral/fileexchange/52700-plot2latex) used for generating figures and visual representations (requires [Inkscape](https://inkscape.org/download/)).
- **Clustering Algorithms**: Algorithms sourced from the textbook [Introduction to Pattern Recognition](https://github.com/pikrakis/Introduction-to-Pattern-Recognition-a-Matlab-Approach).

## Methodology

The data underwent preprocessing where features were first grouped based on their inherent relationships into specific categories: health (child mortality, health, life expectancy, total fertility rate), trade (imports, exports), and finance (income, inflation, GDP). Features were then combined into broader categories, therefore, enhancing the comprehension of inter-feature relationships. 

Following this grouping, the dataset was normalised using a min-max scheme to ensure all features contributed equally. A correlation matrix was constructed and visualised using a heatmap.

For clustering, the k-means algorithm was applied. The initialisation of the centroids was done using the [rand_data_init.m](src/rand_data_init.m) function and iteratively refined clusters using the [k_means.m](src/k_means.m) function until convergence. The final result was the dataset partitioning into three distinct clusters, with each cluster showcasing its associated countries.

## Key Findings
- A strong correlation exists between low income and high child mortality, a known concept in economics and public health.
- Countries exhibiting this correlation typically have underdeveloped economies and weaker healthcare infrastructures.
- Through clustering, the report identifies specific groups of countries that might be more in need of development aid. For instance, countries in Cluster 1 are suggested to be in greater need.
- Initial evidence indicates a potential for more in-depth clustering analysis. However, it's important to note that unsupervised analysis has its limitations, and drawing definitive conclusions can be challenging.

For a more detailed view of the analysis, and the conclusions thereof, have a closer look at the [report](report/main.pdf).

## Sample Output
```bash
           Cluster 1	           Cluster 2	           Cluster 3
          ----------	          ----------	          ----------
             Albania	 Antigua and Barbuda	             Belarus
              Belize	              Bhutan	             Algeria
              Angola	             Armenia	          Azerbaijan
             Bahrain	         Afghanistan	           Argentina
           Australia	             Austria	             Bahamas
                   .	                   .	                   .
                   .	                   .	                   .
                   .	                   .	                   .
               Tonga	             Tunisia	             Ukraine
             Vanuatu	             Vietnam	United Arab Emirates
          Uzbekistan	           Venezuela	               Yemen
              Zambia	         Timor-Leste	              Uganda
      United Kingdom	       United States	             Uruguay
```
