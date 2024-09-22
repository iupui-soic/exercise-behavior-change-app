Personalized Exercise Recommendation System:

Overview:
This project implements a novel exercise recommendation system using Deep Q-Network (DQN) for synthetic data generation, Multi-Armed Contextual Bandit (MAB) for personalized recommendations, and Explainable AI (XAI) for transparency. The system addresses the cold start problem and provides personalized, guideline-based physical activity recommendations.

Repository Contents:

ImprovedDQN_synthetic_data_generation.ipynb: Jupyter notebook for generating synthetic user data using DQN.

base_file_created_including guidelines.csv: CSV file containing structured guidelines for exercise recommendations.

clinical_authoritative_guidelines.txt: Text file with authoritative clinical guidelines used in the project.

synthetic_patient_data.csv: CSV file containing the generated synthetic patient data.

updated_base_file_script_with_guidelines.py: Python script for updating the base file with guidelines.

MAB_implementation.py: Python script implementing the Multi-Armed Contextual Bandit algorithm for personalized exercise recommendations.

XAI_SHAP_analysis.ipynb: Jupyter notebook containing the Explainable AI analysis using SHAP values.

Key Components:
1. Data Preparation and Synthetic Data Generation - 
Utilizes clinical guidelines to create a structured base file
Implements DQN to generate synthetic user profiles, addressing the cold start problem

2. Personalized Recommendation System - 
Implements a Multi-Armed Contextual Bandit (MAB) algorithm using the LinUCB approach
Provides personalized exercise recommendations based on user context and preferences
Balances exploration of new exercise options with exploitation of known effective recommendations

3. Explainable AI Layer - 
Incorporates SHAP (SHapley Additive exPlanations) values for model interpretability
Analyzes feature importance in the recommendation process
Provides transparent rationales for exercise recommendations to enhance user trust and engagement

Installation and Usage:
Clone the repository:
Copygit clone https://github.com/iupui-soic/exercise-behavior-change-app.git

Install required dependencies:
Copypip install -r requirements.txt

To generate synthetic data:
Open and run ImprovedDQN_synthetic_data_generation.ipynb in a Jupyter environment

To update the base file with guidelines:
Copypython updated_base_file_script_with_guidelines.py

To run the MAB algorithm for personalized recommendations:
Copypython MAB_implementation.py

To perform XAI analysis using SHAP values:
Open and run XAI_SHAP_analysis.ipynb in a Jupyter environment

MAB Algorithm Details:
Uses LinUCB (Linear Upper Confidence Bound) approach
Defines three arms: Cardio, Strength, and Flexibility
Considers user context including demographics, medical history, and exercise preferences
Balances exploration and exploitation to optimize recommendations over time
Evaluates performance through simulated user interactions over a 30-day period

XAI Analysis Highlights:
Utilizes SHAP values to quantify the importance of different features in the recommendation process
Key influential features identified: Age, Exercise Frequency, Exercise Duration, Medical History, and Preferred Exercise
Provides insights into arm-specific impacts, enhancing the transparency of the recommendation system
Supports the interpretability of recommendations, crucial for user trust and clinical adoption

Results:
MAB algorithm demonstrated rapid convergence within 15 days of simulated interactions
Cumulative regret 18.9% lower than ε-greedy approach after 30 days
Exploration rate decreased from 40% to 15% over time, showing adaptive behavior
SHAP analysis revealed Age, Exercise Frequency, and Duration as top influencers, with Medical History and Exercise Preferences also significant

Future Work:
Conduct user studies to assess explanation effectiveness
Implement and evaluate the system in real-world mobile app trials
