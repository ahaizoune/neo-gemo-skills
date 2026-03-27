# Extension Review Playbook

Focus on:

- message boundary safety
- permission minimization
- content/background coordination
- parser resilience on unstable DOM
- API error handling and auth token exposure

Look hard at:

- broad permissions without clear need
- unsafe script execution or page interaction
- flows that assume DOM stability or successful messaging
- weak runtime verification for extension-only behavior
