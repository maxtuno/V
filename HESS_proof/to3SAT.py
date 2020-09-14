'''
Jorge Alexis Rubio Sumano A01372074
Servio Tulio Reyes Castillo A01371719

Program which transforms an CNF input into its corresponding 3-SAT representation

'''
import sys

def sat_creator(variables, clause_type):
    global dummy_number, results_clauses
    if clause_type == 1:
        #Beginning clause
        results_clauses.append([variables[0], variables[1], dummy_number])
        dummy_number *= -1

    elif clause_type == 2:
        #Middle clause
        for i in range(len(variables)):
            temp = dummy_number
            dummy_number *= -1
            dummy_number += 1
            results_clauses.append([temp, variables[i], dummy_number])
            dummy_number *= -1

    elif clause_type == 3:
        #Final clause
        for i in range(len(variables)-2):
            temp = dummy_number
            dummy_number *= -1
            dummy_number += 1
            results_clauses.append([temp, variables[i], dummy_number])
            dummy_number *= -1
        results_clauses.append([dummy_number, variables[-2], variables[-1]])
        dummy_number *= -1
        dummy_number += 1

def save_results(file_name):
    global results_clauses
    file2 = open(file_name, "w")
    file2.write("c A 3-SAT instance for the given clauses\n")
    file2.write("p cnf " + str(dummy_number-1) + " " + str(len(results_clauses)) + "\n")
    for clause in results_clauses:
        file2.write(str(clause[0])+" "+str(clause[1]) +" "+str(clause[2])+" 0\n")
    file2.close()

dummy_number = 0
results_clauses = []

def main():
    global dummy_number, results_clause
    try:
        input_file_name = sys.argv[1]
        output_file_name = sys.argv[2]
        file = open(input_file_name)
        content = file.read()
        file.close()
        lines = content.split("\n")
        header = True
        num_line = 0
        total_lines = len(lines)-1
        #Reviews enters at end of file
        limit = total_lines -1
        for _ in range(limit, 0, -1):
            if lines[num_line] == "":
                total_lines -= 1
            else:
                break

        while num_line < total_lines:
            line = lines[num_line]
            if line != "" and line[0] == "c":
                num_line += 1
                continue
            else:
                values = line.split(" ")
                if header:
                    variables = int(values[2])
                    clauses = int(values[3])
                    dummy_number = variables + 1
                    header = False
                else:
                    values.pop()
                    total_variables = len(values)
                    #Case 3 variables
                    if total_variables == 3:
                        results_clauses.append([values[0], values[1], values[2]])
                    else:
                        #Case 1 variable
                        if total_variables == 1:
                            results_clauses.append([values[0], values[0], values[0]])
                        #Case 2 variables
                        elif total_variables == 2:
                            results_clauses.append([values[0], values[1], dummy_number])
                            results_clauses.append([-dummy_number,values[0], values[1]])
                            dummy_number += 1
                        #Case more than 3 variable
                        else:
                            first_clause = values[:2]
                            sat_creator(first_clause, 1)

                            middle_clauses = values[2:len(values)-2]
                            sat_creator(middle_clauses, 2)

                            last_clause = values[len(values)-2:]
                            sat_creator(last_clause, 3)

            num_line += 1
        save_results(output_file_name)
        exit(0)
    except Exception:
        print("Error opening the file")
        exit(-1)

main()