###### COLLABORATOR: [@sanjanathomas10](https://github.com/sanjanathomas10)
<h1 align="center"><strong>How Ultra-Processed is the Supermarket Shelf?</strong></h1>
<h3 align="center">What Proportion of Groceries and Food Items Available on a UK Supermarket Website is Ultra-Processed (UPF)? And, for Any Given UPF Item, What is its Closest Item That is Non-UPF?</h3>

<p align="center">This project investigates the prevalence of ultra-processed foods (UPFs) in UK online grocery retail, using Waitrose as a case study. It was completed as part of DS205's collaborative handoff model, mirroring professional data product development: Part A involved building a Scrapy-based web scraper to collect product data from the Waitrose website; Part B involved wrapping that data in a FastAPI system with NOVA group classification and identification of the nearest non-UPF alternative for any given UPF item. Part A was written by @victoriaelizabethdent; Part B was written by @victoriaelizabethdent using data scraped by @sanjanathomas10 as part of the handoff.</p>

## The Structure
```
├── scraper/           # Part A 
│  ├── README.md
│  ├── items.py
│  ├── settings.py    
│  ├── middlewares.py  
│  └──spiders/         
│    └── waitrose.py    
│    └── __init__.py     
├── api/               # Part B
│  ├── README.md              
│  ├── data_visualisation.py   
│  ├── nova_enrichment.py      
│  ├── models.py            
│  └── main.py  
├── data/
│   ├── raw/           
│   └── processed/     
├── environment.yml
├── CONTRIBUTING.md
└── README.md   
```

## The Environment Setup
Create the conda environment:

```bash
conda env create -f environment.yml
```

Activate it:

```bash
conda activate food
```

If `environment.yml` changes, update your environment:

```bash
conda env update -f environment.yml --prune
```

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for collaboration guidelines developed during the course.

<h4 align="center">This is an assessment for DS205: Advanced Data Manipulation. See the [assignment page](https://lse-dsi.github.io/DS205/2025-2026/winter-term/assessments/problem-set-1.html) for full instructions.</h4>
