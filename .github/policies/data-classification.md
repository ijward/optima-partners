# Data Classification Policy

The A9 system classifies all work by sensitivity level to determine what can be validated externally.

## Classification Levels

| Level | Definition | External Validation | Examples |
|-------|---|---|---|
| **PUBLIC** | Code/documentation with no confidentiality requirements | ✅ Allowed | Utility functions, UI components, public libraries, documentation |
| **INTERNAL** | Code used internally but not externally sensitive | ⚠️ Internal review only | Configuration utilities, internal tools, non-critical infrastructure |
| **CONFIDENTIAL** | Proprietary code, algorithms, or business logic | ❌ Prohibited | Custom encryption, proprietary algorithms, client-specific implementations |
| **SECRET** | Security-critical, highly sensitive, or regulatory data | ❌ Absolutely prohibited | Authentication, authorization, payment systems, personal data handling |

## Usage

All tasks assigned to a9-quality-assurance must be pre-classified by A9 Task Manager. Work classified below PUBLIC is automatically excluded from external model validation.

For questions about classification, contact A9 Task Manager or A9 Security Manager.
