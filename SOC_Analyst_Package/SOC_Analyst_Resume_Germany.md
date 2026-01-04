# GURUVENU KAMANURU
**SOC Analyst | Cybersecurity Professional | Security Operations**

---

## CONTACT INFORMATION
**Location:** Wolfsburg, Germany  
**Phone:** +49 176 239 73753  
**Email:** guruvenu.kamanuru@gmail.com  
**LinkedIn:** linkedin.com/in/guruvenu-kamanuru  
**GitHub:** [Your GitHub Profile - include SOC Lab project]

---

## PROFESSIONAL SUMMARY

Mainframe Developer transitioning to SOC Analyst roles with 5+ years of experience in production support, data security, and system monitoring. Currently completing Ironhack Cybersecurity Bootcamp (2024-2025) and 42 Wolfsburg Software Engineering Diploma. Built comprehensive Docker-based SOC Detection Lab demonstrating practical skills in SIEM operations, IDS/IPS, log analysis, and threat detection. Strong foundation in data validation, secure data transfer, storage security, system monitoring, and compliance reporting. Authorized to work in Germany without visa sponsorship.

**Core Competencies:** Data Security | System Monitoring | Log Analysis | Incident Management | SIEM Operations | Threat Detection | Network Security | Production Support

---

## TECHNICAL SKILLS

### Security Operations & Analysis
- **SIEM/Log Management:** Splunk, ELK Stack (Elasticsearch, Logstash, Kibana), Wazuh
- **IDS/IPS:** Suricata, Snort, Network Traffic Analysis
- **Threat Detection:** MITRE ATT&CK Framework, Kill Chain Analysis, IOC Identification
- **Security Monitoring:** Real-time Alert Triage, Log Correlation, Anomaly Detection
- **Incident Response:** Evidence Collection, Root Cause Analysis, Containment Strategies

### Security Tools & Technologies
- **Network Security:** Wireshark, Nmap, Netcat, TCPdump, Network Protocol Analysis
- **Vulnerability Assessment:** Nessus, OpenVAS, Nikto, OWASP ZAP, Qualys
- **Penetration Testing:** Metasploit Framework, Burp Suite, Hydra, John the Ripper
- **Forensics:** Autopsy, Volatility, FTK Imager, Memory Analysis
- **Endpoint Security:** EDR concepts, File Integrity Monitoring (FIM), Host-based IDS

### Operating Systems & Infrastructure
- **Linux:** Kali Linux, Ubuntu, Security Hardening, Bash Scripting
- **Windows:** PowerShell, Event Log Analysis, Active Directory Security
- **Containerization:** Docker, Docker Compose, Container Security
- **Cloud Security:** AWS (EC2, S3, IAM), Security Groups, Cloud Architecture

### Programming & Scripting
- **Languages:** Python (Security Automation), Bash, PowerShell, SQL
- **Security Scripting:** Log parsers, IOC extractors, Automated threat hunting scripts
- **Data Analysis:** Python (Pandas, NumPy), SQL queries for log analysis

### Frameworks & Standards
- **Security Frameworks:** NIST Cybersecurity Framework, MITRE ATT&CK, Cyber Kill Chain
- **Compliance:** OWASP Top 10, ISO 27001 Awareness, GDPR Basics
- **Methodologies:** Security Incident & Event Management (SIEM), SOC Best Practices

---

## HANDS-ON CYBERSECURITY PROJECTS

### Docker-Based SOC Detection Lab | Personal Project | 2024-Present
**Comprehensive Security Operations Center simulation for threat detection and incident response training**

**Architecture & Implementation:**
- Designed and deployed containerized SOC infrastructure using Docker Compose (15-20 min deployment vs 4-6 hours for VM-based setup)
- Built multi-container environment: Elasticsearch (SIEM core), Logstash (log pipeline), Kibana (visualization), Wazuh (HIDS), Suricata (IDS), Filebeat (log shipper)
- Configured custom Docker network (172.20.0.0/16) with isolated attacker, victim, and monitoring segments
- Created attack simulation environment: Kali Linux (attacker), Ubuntu web server (victim), Windows log simulation

**Security Operations & Detection:**
- Developed detection rules in Kibana (KQL) for common attack patterns: credential dumping, brute force, SQL injection, privilege escalation
- Configured Wazuh for file integrity monitoring (FIM), vulnerability detection, and compliance auditing
- Implemented Suricata IDS with custom rule sets for network-based threat detection
- Built Logstash pipelines for log normalization and enrichment from multiple sources

**Threat Simulation & Analysis:**
- Executed MITRE ATT&CK-mapped attack scenarios: reconnaissance (Nmap), exploitation (Metasploit), post-exploitation techniques
- Generated and analyzed security events: failed authentication attempts, web application attacks, network scanning
- Performed end-to-end incident response: alert triage → investigation → containment → documentation
- Created detection playbooks for common attack vectors with step-by-step investigation procedures

**Technical Achievements:**
- Reduced lab deployment time by 80% compared to traditional VM-based setup (15 min vs 4-6 hours)
- Optimized resource usage: 8-12GB RAM vs 16GB+ for VMs, enabling portable demo environment
- Documented entire lab setup with deployment scripts for reproducible security testing
- Demonstrated ability to quickly spin up security infrastructure for threat hunting exercises

**Tools & Technologies:** Docker, Docker Compose, ELK Stack, Wazuh, Suricata, Filebeat, Kali Linux, Metasploit, Nmap, Wireshark, KQL, Bash scripting

**Business Value:** Interview-ready portable SOC lab demonstrating practical security operations skills, attack simulation capabilities, and modern containerized infrastructure knowledge

---

### Network Security & Penetration Testing Lab | Ironhack Bootcamp | 2024-2025
- Conducted vulnerability assessments on intentionally vulnerable applications (DVWA, bWAPP)
- Performed network penetration testing: reconnaissance, scanning, exploitation, post-exploitation
- Analyzed network traffic with Wireshark to identify malicious patterns and data exfiltration
- Documented findings in professional penetration testing reports with remediation recommendations

---

### SIEM Log Analysis & Threat Hunting | Personal Project | 2024
- Configured Splunk to ingest logs from multiple sources (Windows Event Logs, Syslog, Apache)
- Created custom dashboards for security monitoring: failed logins, privilege escalation, suspicious processes
- Developed correlation rules to detect multi-stage attacks across different log sources
- Practiced threat hunting using MITRE ATT&CK techniques across authentication and lateral movement

---

## PROFESSIONAL EXPERIENCE

### Sr. Software Developer | GalaxE.Solutions, Hyderabad, India | Nov 2022 – Jul 2024
**US Healthcare Project – Polar Eligibility | Mainframe-ELK Integration**

Developed automation solutions for processing Medicaid, Medicare, and Commercial client data. Led implementation of Mainframe-to-Elasticsearch integration project for centralized log management and monitoring.

**Key Responsibilities:**
- **Mainframe-ELK Integration:** Designed and implemented automated file transmission application to transfer log data from mainframe systems to Elasticsearch for centralized monitoring and analysis
- Built data extraction routines in COBOL to capture and format mainframe application logs, system logs, and batch job outputs for Elasticsearch ingestion
- Developed automated data switch system using COBOL, JCL, and shell scripts to streamline log data transmission and healthcare data reporting workflows
- Configured MFT (Managed File Transfer) and SFTP connections to securely transmit log files from mainframe to Elasticsearch cluster
- Created data transformation pipelines to convert mainframe log formats (COBOL copybooks, VSAM records) into JSON for Elasticsearch compatibility
- Built and maintained batch programs using COBOL, JCL, DB2, and VSAM for healthcare data processing
- Performed data validation and quality checks to ensure accuracy and compliance with HIPAA requirements
- Provided 24/7 production support, monitoring batch cycles and resolving incidents to ensure timely completion
- Analyzed system logs and batch job outputs using Elasticsearch queries to identify anomalies and troubleshoot issues
- Conducted QA testing, prepared test plans, and supported UAT for new enhancements
- Managed code versioning and deployment using Endevor and Jenkins

**Security, Monitoring & Compliance:**
- Implemented secure log transmission from mainframe to Elasticsearch using encryption protocols (SFTP, MFT)
- Enabled real-time log monitoring and alerting capabilities by integrating mainframe systems with ELK Stack
- Monitored data access controls and maintained audit trails for HIPAA compliance
- Identified and resolved data integrity issues affecting security posture through log analysis
- Generated compliance reports by querying Elasticsearch for audit trail data and system events
- Facilitated faster incident detection and troubleshooting through centralized log aggregation

*Technical Environment:* COBOL, JCL, DB2, VSAM, Elasticsearch, MFT, SFTP, AWS, Jenkins, Endevor, Shell Scripting, Unix/Linux, JSON

---

### Associate Developer | Cognizant Technologies, Chennai, India | May 2019 – Nov 2022
**Retail Import-Export Project – Ford Motor Company**

Worked on support and upgrade project managing transactions between importers and exporters with focus on data security and system reliability.

**Key Responsibilities:**
- Developed and maintained batch programs using COBOL, DB2, JCL, and IMSDB for order processing
- Managed secure data exchanges via SFTP across various business markets and trading partners
- Performed data validation and integrity checks for financial transactions (CIF850, CIF810, CIF856)
- Conducted impact analysis for requirement changes and prepared Technical Specification Documents
- Created test plans for unit testing and QA validation ensuring quality deployments
- Provided production support for end-to-end order flow from receipt to invoice generation
- Monitored system performance and logs to identify and resolve issues
- Collaborated with business teams through JAD sessions to gather requirements

**Security & Monitoring Aspects:**
- Implemented secure file transfer protocols for sensitive business data
- Maintained audit trails and logs for regulatory compliance
- Monitored batch processing for anomalies and system issues
- Ensured data integrity through validation routines and error handling

*Technical Environment:* COBOL, DB2, IMSDB, JCL, SFTP, Unix/Linux, JIRA

---

### Desktop Support Engineer | NetConnectGlobal, Bangalore, India | Oct 2016 – Jul 2017
**Banking Sector – Societe Generale**

Provided IT infrastructure support and network administration for banking operations.

**Key Responsibilities:**
- Managed network administration including IP handling, remote access allocations, and connectivity troubleshooting
- Administered user access rights, password resets, and authentication issues
- Resolved ITSM tickets related to hardware, software, and network connectivity with 95% SLA compliance
- Maintained IT asset inventory and hardware lifecycle management
- Performed secure data sanitization and device disposal following banking security standards
- Supported production systems ensuring uptime and stability

*Technical Environment:* Windows, Active Directory, Network Administration, ITSM Tools, Data Destruction Tools

---

### Trainee Engineer | TLE Technologies, Bangalore, India | Sep 2015 – Sep 2016
**Aviation Sector – Airbus**

- Managed IT asset lifecycle and inventory tracking
- Performed hardware/software installations, configuration, and troubleshooting
- Conducted secure data destruction following industry standards
- Handled ITSM ticket resolution for end-user support

---

## EDUCATION

**Cybersecurity Bootcamp** | Ironhack | Apr 2025 – Oct 2025  
*Focus: Cybersecurity & Network Security Specialist, Digital Forensics, Threat Intelligence*

**Diploma in Software Engineering** | 42 Wolfsburg, Germany | Sep 2024 – Feb 2026  
*Focus: Computer Science, Programming, System Architecture*

**M.Tech in Mechanical Engineering** | JNTU Anantapur, India | Aug 2017 – Aug 2019

**B.Tech in Aeronautical Engineering** | Malla Reddy College, India | Aug 2011 – Aug 2015

---

## CERTIFICATIONS

- **RMT CY PT** (Cybersecurity Penetration Testing) | Expected: April 2025
- **Excel: Mother of Business Intelligence** | Completed
- **CompTIA Security+** | In Progress (Expected: Q2 2025)

---

## ADDITIONAL SKILLS

**Languages:**  
- English: Proficient  
- German: Beginner (A1/A2 level)  
- Hindi: Native  
- Telugu: Native

**Soft Skills:**  
- Analytical Thinking & Problem Solving
- Attention to Detail in Security Analysis
- Team Collaboration in Incident Response
- Clear Communication of Technical Security Concepts
- Continuous Learning in Evolving Threat Landscape

**Work Authorization:**  
Authorized to work in Germany | No visa sponsorship required

---

## PROFESSIONAL INTERESTS

- Threat Intelligence & Malware Analysis
- Cloud Security (AWS, Azure)
- Security Automation & SOAR
- Incident Response & Digital Forensics
- Red Team / Blue Team Exercises
- Security Research & Vulnerability Disclosure

---

## CAREER TRANSITION TO SOC ANALYST

Transitioning from Mainframe Development to SOC Analyst roles, leveraging 5+ years of experience in:

**Data Security Foundation:**
- Managed secure transmission and storage of sensitive healthcare (HIPAA) and financial data
- Implemented data validation routines and integrity checks preventing data breaches
- Utilized encryption protocols (SFTP, MFT, AWS) for secure data transfer
- Maintained audit trails and compliance reports for regulatory requirements

**System Monitoring & Incident Management:**
- Provided 24/7 production support for critical systems in healthcare and retail sectors
- Monitored batch job logs and system events to identify anomalies and failures
- Performed root cause analysis and troubleshooting for system incidents
- Ensured system uptime and resolved issues impacting business operations

**Trained for SOC Operations:**
- Currently completing Ironhack Cybersecurity Bootcamp (2024-2025) focused on SOC Analyst skills
- Built Docker-based SOC Detection Lab with ELK Stack, Wazuh, and Suricata for hands-on practice
- Developed detection rules, threat hunting techniques, and incident response procedures
- Practiced with industry-standard tools: Splunk, Wireshark, Nmap, Metasploit, Burp Suite

Combining operational IT experience with targeted cybersecurity training to contribute as a SOC Analyst protecting organizations from evolving threats.

---

*References available upon request*
