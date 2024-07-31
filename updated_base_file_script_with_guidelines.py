# -*- coding: utf-8 -*-
"""
Created on Thu Jul 18 16:28:06 2024

@author: Parvati
"""
import csv
import itertools
import pandas as pd
from itertools import pro

# Define the attributes
ages = list(range(18, 66))
sexes = ['Male', 'Female', 'Non-Binary', 'Prefer not to say']
medical_histories = ['diabetes', 'hypertension', 'COPD', 'high cholesterol', 'back pain', 'spondylitis',
                     'none', 'obesity', 'kidney disease', 'osteoarthritis', 'stroke', 'cardiac disease', 'Alzheimer’s']
preferred_exercises = ['cardio', 'strength', 'flexibility']
exercise_durations = ['30-45', '45-60', '0-15', '15-30', '60-75', '75-90', '90-105', '105-120']
exercise_frequencies = list(range(1, 8))

# Define the calculate_reward function based on updated logic
def calculate_reward(age, sex, medical_history, preferred_exercise, exercise_frequency, exercise_duration):
    if 18 <= age <= 65:
        if medical_history in ['cardiac disease', 'hypertension', 'high cholesterol']:
            if preferred_exercise == 'cardio':
                if exercise_duration == '0-15' and exercise_frequency in [1, 2, 3, 4, 5, 6, 7]:
                    return 0.4
                elif exercise_duration in ['15-30', '30-45', '45-60']:
                    if exercise_frequency in [4, 5, 6, 7]:
                        return 0.9
                    elif exercise_frequency in [1, 2, 3]:
                        return 0.7
                elif exercise_duration in ['60-75', '75-90']:
                    if exercise_frequency in [1, 2]:
                        return 0.5
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.9
                elif exercise_duration in ['90-105', '105-120']:
                    if exercise_frequency in [1, 2]:
                        return 0.4
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.8
            elif preferred_exercise in ['strength', 'flexibility']:
                if exercise_duration == '0-15' and exercise_frequency in [1, 2, 3, 4, 5, 6, 7]:
                    return 0.3
                elif exercise_duration in ['15-30', '30-45', '45-60']:
                    if exercise_frequency in [4, 5, 6, 7]:
                        return 0.8
                    elif exercise_frequency in [1, 2, 3]:
                        return 0.6
                elif exercise_duration in ['60-75', '75-90']:
                    if exercise_frequency in [1, 2]:
                        return 0.4
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.8
                elif exercise_duration in ['90-105', '105-120']:
                    if exercise_frequency in [1, 2]:
                        return 0.3
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.7
        elif medical_history == 'kidney disease':
            if preferred_exercise == 'cardio':
                if exercise_duration in ['30-45', '45-60']:
                    if exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.9
                    elif exercise_frequency in [1, 2]:
                        return 0.6
                elif exercise_duration in ['0-15', '15-30']:
                    return 0.5
                elif exercise_duration in ['60-75', '75-90', '90-105', '105-120']:
                    return 0.3
            elif preferred_exercise in ['strength', 'flexibility']:
                if exercise_duration in ['30-45', '45-60']:
                    if exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.7
                    elif exercise_frequency in [1, 2]:
                        return 0.5
                elif exercise_duration in ['0-15', '15-30']:
                    return 0.4
                elif exercise_duration in ['60-75', '75-90', '90-105', '105-120']:
                    return 0.3
        elif medical_history in ['diabetes', 'Alzheimer’s', 'back pain', 'spondylitis', 'osteoarthritis', 'none']:
            if preferred_exercise in ['cardio', 'strength', 'flexibility']:
                if exercise_duration in ['0-15', '15-30']:
                    if exercise_frequency in [1, 2, 3, 4]:
                        return 0.3
                    elif exercise_frequency in [5, 6, 7]:
                        return 0.5
                elif exercise_duration in ['30-45', '45-60']:
                    if exercise_frequency in [4, 5, 6, 7]:
                        return 0.9
                    elif exercise_frequency in [1, 2, 3]:
                        return 0.7
                elif exercise_duration in ['60-75', '75-90']:
                    if exercise_frequency in [1, 2]:
                        return 0.5
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.9
                elif exercise_duration in ['90-105', '105-120']:
                    if exercise_frequency in [1, 2]:
                        return 0.4
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.8
        elif medical_history == 'obesity':
            if preferred_exercise in ['cardio', 'strength', 'flexibility']:
                if exercise_duration == '0-15':
                    return 0.4
                elif exercise_duration in ['15-30', '30-45', '45-60']:
                    if exercise_frequency in [4, 5, 6, 7]:
                        return 0.9
                    elif exercise_frequency in [1, 2, 3]:
                        return 0.7
                elif exercise_duration in ['60-75', '75-90']:
                    if exercise_frequency in [1, 2]:
                        return 0.5
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.9
                elif exercise_duration in ['90-105', '105-120']:
                    if exercise_frequency in [1, 2]:
                        return 0.5
                    elif exercise_frequency in [3, 4, 5, 6, 7]:
                        return 0.8
        elif medical_history == 'COPD':
            if preferred_exercise in ['cardio', 'strength']:
                if exercise_duration in ['0-15', '15-30']:
                    if exercise_frequency in [1, 2, 5, 6, 7]:
                        return 0.8
                    elif exercise_frequency in [3, 4]:
                        return 0.9
                elif exercise_duration in ['30-45', '45-60', '60-75']:
                    return 0.5
                elif exercise_duration in ['75-90', '90-105', '105-120']:
                    return 0.5
            elif preferred_exercise == 'flexibility':
                if exercise_duration in ['0-15', '15-30']:
                    if exercise_frequency in [1, 2, 5, 6, 7]:
                        return 0.7
                    elif exercise_frequency in [3, 4]:
                        return 0.8
                elif exercise_duration in ['30-45', '45-60', '60-75']:
                    return 0.5
                elif exercise_duration in ['75-90', '90-105', '105-120']:
                    return 0.5
        elif medical_history == 'stroke':
            if preferred_exercise == 'cardio':
                if exercise_duration in ['0-15', '15-30']:
                    if exercise_frequency in [5, 6, 7, 1]:
                        return 0.7
                    elif exercise_frequency in [2, 3, 4]:
                        return 0.9
                elif exercise_duration in ['30-45', '45-60', '60-75']:
                    return 0.5
                elif exercise_duration in ['75-90', '90-105', '105-120']:
                    return 0.3
            elif preferred_exercise in ['strength', 'flexibility']:
                if exercise_duration in ['0-15', '15-30']:
                    if exercise_frequency in [5, 6, 7, 1]:
                        return 0.6
                    elif exercise_frequency in [2, 3, 4]:
                        return 0.7
                elif exercise_duration in ['30-45', '45-60', '60-75']:
                    return 0.4
                elif exercise_duration in ['75-90', '90-105', '105-120']:
                    return 0.2

    return 0.1

# Generate all possible combinations
combinations = list(itertools.product(ages, sexes, medical_histories, preferred_exercises, exercise_frequencies, exercise_durations))

# Generate patient IDs
patient_ids = list(range(1000, 1000 + len(combinations)))

# Calculate rewards for all combinations
data = []
for idx, combination in enumerate(combinations):
    age, sex, medical_history, preferred_exercise, exercise_frequency, exercise_duration = combination
    reward = calculate_reward(age, sex, medical_history, preferred_exercise, exercise_frequency, exercise_duration)
    patient_id = patient_ids[idx]
    data.append([patient_id, age, sex, medical_history, preferred_exercise, exercise_frequency, exercise_duration, reward])

# Write to CSV file with UTF-8 encoding
with open('combinations_with_rewards.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['Patient ID', 'Age', 'Sex', 'Medical History', 'Preferred Exercise', 'Exercise Frequency', 'Exercise Duration', 'Reward'])
    writer.writerows(data)

# Read CSV file to check the data
df = pd.read_csv('combinations_with_rewards.csv', encoding='utf-8')
print(df.head())
