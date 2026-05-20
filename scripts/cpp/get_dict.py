from bs4 import BeautifulSoup
import re

def get_dict(filepath):
    
    dict = {
        'name' : "", 
        'signatures' : [],
        'description' : [],
        'parameters' : [],
        'return value' : [],
        'complexity' : [],
        'exceptions' : [],
        'notes' : []
    }

    with open(filepath, 'r', encoding='utf-8', errors='ignore') as file:
        soup = BeautifulSoup(file, 'html.parser') 


    h1 = soup.find('h1')
    
    if h1 is not None:
        dict['name'] = ''.join(h1.stripped_strings)

    decl_table = soup.find('table', class_='t-dcl-begin')

    if decl_table is not None:
        for t in decl_table:
            lines = re.split(r'\(\S.*?\S\)', ' '.join(t.stripped_strings))
            for i, line in enumerate(lines, start=1): 
                if line != ' ' and line != '':
                    dict['signatures'].append(f"{line.strip()} ({i})")
    
        next = decl_table.find_next_sibling()

        key = 'description'

        while next is not None:

            if 'Example' in next.stripped_strings:
                break
            if next.name == 'table':
                rows = next.find_all('tr')
                if rows is not None:
                    for r in rows:
                        s = ' '.join(r.stripped_strings)
                        if s.strip().lower() in dict:
                            key = s.strip().lower()
                        else:
                            dict[key].append(s)
            else:
                s = ' '.join(next.stripped_strings)
                if s.strip().lower() in dict:
                    key = s.strip().lower()
                else:
                    dict[key].append(s)

            next = next.find_next_sibling()

            
    return dict 
