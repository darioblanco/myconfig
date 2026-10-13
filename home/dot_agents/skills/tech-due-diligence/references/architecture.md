# Architecture review

Describe the system as it is, then judge it against what the business needs next.

## Describe

- **Context.** Users, external systems, third-party services and data flowing between them.
- **Components.** Services, apps, jobs and libraries; what each owns; how they communicate
  (HTTP, events, shared database, files). Draw a simple diagram.
- **Data.** Stores, schemas, ownership, migrations, retention, backups. Where personal or
  sensitive data lives and who can read it.
- **Runtime.** Hosting, regions, infrastructure as code, how environments differ.
- **Key choices.** Languages, frameworks, managed services; the reasons if documented (ADRs).

## Judge

- **Boundaries and coupling.** Clear module and service boundaries, or a shared database and
  cross-cutting changes for every feature?
- **Simplicity.** Is the complexity proportionate to the product and team size (for example,
  many microservices for a small team)?
- **Reliability.** Single points of failure, retries and timeouts, idempotency, graceful
  degradation, data consistency across services.
- **Scalability and cost.** What breaks first at 10× load or data; the main cost drivers.
- **Evolvability.** How hard the next likely changes are; dead code and abandoned paths.
- **Lock-in.** Vendor, framework or single-person knowledge that would be costly to replace.
- **Technical debt.** Known workarounds, TODO density in critical paths, outdated runtimes or
  frameworks past end of life.

Red flags: no one can explain how data flows end to end; production differs from what the code
and infrastructure describe; critical components on unsupported versions.
