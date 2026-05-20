import os
from get_dict import get_dict

def build_list(dir, list):
    if not os.path.isdir(dir):
        raise NotADirectoryError(f"expecting {dir} to be a directory")

    contents = os.listdir(dir)

    list = []

    for item in contents:
        item_path = os.path.join(dir, item)
        if os.path.isfile(item_path):
            print(f"{item_path} is a file, building dict")
            list.append(get_dict(item_path))
            continue
        print(f"{item_path} is a dir, recursing in")
        list.extend(build_list(item_path, list))
        

    return list






        




    


