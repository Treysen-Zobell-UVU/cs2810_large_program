
def get_hex(letter):
    return f'x{hex(ord(letter))[2:].upper()}'


def gen_str(string, delimiter='\n'):
    file_contents = ''
    for letter in string:
        h = get_hex(letter)
        l = letter.replace('\n', '\\n')
        file_contents += f'\t.FILL {h} ; {l}\n'
    d = delimiter.replace('\n', '\\n')
    file_contents += f'\t.FILL {get_hex(delimiter)} ; {d}\n'
    return file_contents


print(gen_str('ERROR, INVALID INSTRUCTION', '\n'))
