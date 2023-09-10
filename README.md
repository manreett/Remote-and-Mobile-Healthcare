# Remote Healthcare Monitoring System

## Introduction

The rise of remote healthcare systems has brought numerous benefits, including the ability to provide valuable health indicators, reduce the need for emergency hospital visits, and minimize the risk of disease transmission. This project focuses on developing a remote healthcare monitoring system with a focus on Electrocardiogram (ECG), Photoplethysmography (PPG), and Beats per Minute (BPM) measurements.

## Overview of the Project

The main objective of this project is to create a mobile medical monitoring system suitable for homecare settings, offering real-time monitoring capabilities. The system enables users to monitor their vital signs at home, collect data, and perform real-time analysis. The development of such a system is crucial to meet the growing demand for remote healthcare solutions and improve patient outcomes.

### Project Scope

The scope of this project encompasses:

- Researching and selecting appropriate hardware for the sensors.
- Developing a prototype capable of analyzing and collecting data.
- Creating a user-friendly mobile application for easy use by untrained users.
- Ensuring functionality in an uncontrolled environment.
- Developing a functioning prototype capable of collecting and displaying data while keeping costs low.

## Requirements Specifications

The primary goal is to create a mobile medical monitoring system using an Arduino board and sensors, coupled with a cloud hosting service to display data on a mobile application. The collected data for the user's vital signs should be continuously updated for real-time analysis.

## Proposed Solution

### Hardware Components

- Arduino MEGA 2560
- ESP3266
- SEN-11574 (Pulse Sensor)
- MAX30102 (Blood Oxygen)
- AD8232 (ECG Sensor)

### Software Components

- Digital Ocean Cloud Hosting Service
- MySQL Database
- Android Studio for Android Application Development

The proposed solution involves both hardware and software components. The Arduino unit serves as the primary data collection and transmission source, sending data to the MySQL database via WiFi. The Digital Ocean Cloud Hosting Service hosts the MySQL data and facilitates API requests to retrieve sensor data from the Arduino. The data is then sent to the mobile application using API endpoints. Users can access real-time data updates, and administrators have access to a dashboard for direct data viewing.

## Getting Started

To get started with this project, follow these steps:

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/your-username/remote-healthcare-monitoring.git
