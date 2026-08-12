# ConditionExprV1

Original OpenAPI schema: `ConditionExprV1`

A logical condition expression that can combine multiple conditions using AND/OR operators, or perform field comparisons using Is/IsNot operators.

## Fields

- `and`: array
  - Logical AND operation. All conditions in the array must be true.
- `or`: array
  - Logical OR operation. At least one condition in the array must be true.
- `is`: ComparisonCondition
- `isNot`: ComparisonCondition

## Example JSON

```json
{"and": [], "or": [], "is": "ComparisonCondition", "isNot": "ComparisonCondition"}
```
