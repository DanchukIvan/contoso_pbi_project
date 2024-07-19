from copy import copy
from os import getenv

import polars

"""
The script generates a reference table of RFM codes with descriptions for loading into the database. 
In the database, this dataset acts as a base table for assigning RFM codes to clients for each date.
An example of the result of the script can be seen in the RFM codes.csv file.
"""

champions = [555, 554, 544, 545, 454, 455, 445]
loyal_customers = [543, 444, 435, 355, 354, 345, 344, 335]
potential_loyal = [553, 551, 552, 541, 542, 533, 532, 531, 452, 451, 442, 441, 431, 453, 433, 432, 423, 353, 352, 351, 342, 341, 333, 323]
new_customers = [512, 511, 422, 421,412, 411, 311]
promising = [525, 524, 523, 522, 521, 515, 514, 513, 425,424, 413,414,415, 315, 314, 313]
need_attention = [535, 534, 443, 434, 343, 334, 325, 324]
cannot_loos_them = [155, 154, 144, 214,215,115, 114, 113]
sleep = [331, 321, 312, 221, 213]
at_risk = [255, 254, 245, 244, 253, 252, 243, 242, 235, 234, 225, 224, 153, 152, 145, 143, 142, 135, 134, 133, 125, 124]
hibernating = [332, 322, 231, 241, 251, 233, 232, 223, 222, 132, 123, 122, 212, 211]
lost = [111, 112, 121, 131, 141, 151]

dicts = []
index = 0
g = copy(globals())
for var, value in g.items():
    for_df_dict = dict()
    if isinstance(value, list) and len([i for i in value if isinstance(i, int)]):
        index += 1
        var = var.split("_")
        name = " ".join(var).capitalize()
        for_df_dict.update({"Rank": index, "Segment": name, "Codes": value})
        dicts.append(for_df_dict)
df = polars.from_dicts(dicts)
df = df.explode("Codes")
df.write_csv(getenv('RFM_PATH'))