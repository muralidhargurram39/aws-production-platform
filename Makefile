.PHONY: validate plan apply lint security

validate:
	./scripts/validate.sh

plan:
	./scripts/plan.sh

apply:
	./scripts/apply.sh

lint:
	./scripts/lint.sh

security:
	./scripts/security.sh
