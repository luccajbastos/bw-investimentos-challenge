# Desafio de Programação — Conciliação de Transações Financeiras

## Objetivo
Escrever uma função `reconcile_accounts` que realize a conciliação (ou batimento) entre dois grupos de transações financeiras.  

A função deve comparar duas listas de transações e indicar se cada transação foi encontrada (`FOUND`) ou não (`MISSING`) na outra lista, considerando duplicatas e pequenas variações de data (dia anterior ou posterior).

---

## Regras do desafio

### Entrada
- Duas listas de listas (`transactions1` e `transactions2`), representando linhas de dados financeiros.  
- Cada linha tem quatro colunas (todas como **strings**):
  1. **Data**: `YYYY-MM-DD`
  2. **Departamento**
  3. **Valor**
  4. **Beneficiário`

## Regras de correspondência
- Cada transação de uma lista deve corresponder a no máximo uma transação da outra lista.
- Pode haver transações duplicadas; cada correspondência é única.
- A data da transação pode ser do dia anterior, igual ou do dia seguinte, desde que os demais campos coincidam.
- Se houver múltiplas correspondências possíveis, a transação deve se ligar à que ocorre mais cedo.

# Como rodar
```shell
conda create -y -n myenv python=3.9
conda activate myenv
python3 main.py
```

