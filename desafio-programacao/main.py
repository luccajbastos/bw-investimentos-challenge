from datetime import datetime, timedelta

transactions_01 = [
    ["2020-12-04","Tecnologia","16.00","Bitbucket"],   # igual em 02 -> FOUND
    ["2020-12-04","Jurídico","60.00","LinkSquares"],  # igual em 02 -> FOUND
    ["2020-12-05","Tecnologia","50.00","AWS"],        # não tem igual -> MISSING
    ["2020-12-25","Tecnologia","10.00","AWS"],        # bate com 2020-12-24 em 02 (dia anterior)
    ["2020-12-25","Tecnologia","10.00","AWS"],        # duplicata: só 1 bate, a outra fica MISSING
    ["2020-12-26","Marketing","30.00","Google"],      # igual em 02 (mesma data)
    ["2020-12-27","Financeiro","100.00","Oracle"],    # bate com 2020-12-28 em 02 (dia seguinte)
    ["2020-12-30","Financeiro","200.00","Oracle"],    # não tem par → MISSING
]

transactions_02 = [
    ["2020-12-04","Tecnologia","16.00","Bitbucket"],  # FOUND
    ["2020-12-05","Tecnologia","49.99","AWS"],        # diferente -> MISSING
    ["2020-12-04","Jurídico","60.00","LinkSquares"],  # FOUND
    ["2020-12-24","Tecnologia","10.00","AWS"],        # bate com 2020-12-25 em 01 (dia posterior)
    ["2020-12-26","Marketing","30.00","Google"],      # FOUND
    ["2020-12-28","Financeiro","100.00","Oracle"],    # bate com 2020-12-27 em 01 (dia anterior)
    ["2020-12-31","Financeiro","300.00","Oracle"],    # não tem par -> MISSING
]


# Concilia duas listas de transações financeiras e retorna cópias com uma coluna de status (FOUND/MISSING).

def reconcile_accounts(a, b):
    def to_date(s): return datetime.strptime(s, "%Y-%m-%d").date()
    def key(row): return (row[1], row[2], row[3])

    # prepara estrutura para B: dicionário { chave : { data : [indices livres] } }
    index_map = {}
    for j, row in enumerate(b):
        k = key(row)
        d = to_date(row[0])
        index_map.setdefault(k, {}).setdefault(d, []).append(j)

    found_a = [False] * len(a)
    found_b = [False] * len(b)

    # Processa A em ordem cronológica
    indices_a = sorted(range(len(a)), key=lambda i: to_date(a[i][0]))

    for i in indices_a:
        row = a[i]
        k = key(row)
        d = to_date(row[0])
        if k not in index_map:
            continue

        for cand in (d - timedelta(days=1), d, d + timedelta(days=1)):
            if cand in index_map[k] and index_map[k][cand]:
                j = index_map[k][cand].pop(0)  # consome uma ocorrência de B
                found_a[i] = True
                found_b[j] = True
                break

    out_a = [row[:] + (["FOUND"] if found_a[i] else ["MISSING"]) for i, row in enumerate(a)]
    out_b = [row[:] + (["FOUND"] if found_b[j] else ["MISSING"]) for j, row in enumerate(b)]
    return out_a, out_b

def print_table(title, data):
    print(title)
    print("=" * len(title))
    headers = ["Data", "Departamento", "Valor", "Beneficiário", "Status"]
    print("{:<12} | {:<12} | {:<8} | {:<15} | {:<8}".format(*headers))
    print("-" * 65)
    for row in data:
        print("{:<12} | {:<12} | {:<8} | {:<15} | {:<8}".format(*row))
    print()

if __name__ == "__main__":
    out1, out2 = reconcile_accounts(transactions_01, transactions_02)

    print_table("Resultado 1", out1)
    print_table("Resultado 2", out2)