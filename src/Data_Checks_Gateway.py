# This is to check the Water Quality Summary Data / PWS following GATEWAY, 2022
# Appendix F of HTG
import pandas as pd

valid_units = {
    1005: 'ug/l',
    2050: 'ug/l',
    2456: 'ug/l',
    2950: 'ug/l',
    2039: 'ug/l',
    1040: 'mg/l',
    2987: 'ug/l', 
    2984: 'ug/l',
    4010: 'ug/l',
    4006: 'ug/l'
}

WQL = pd.read_csv('/Users/babak.jfard/projects/ETHTracking/Data/Water_Data/Summaries_Calculated_20230407.csv')

WQL.insert(0, 'RowIdentifier', WQL.index)
# Duplicate records
# -----------------
# for WQL files
# Check for duplicates of Year x Aggregation Code (MX, M) x Summary Time Period (A, Q) x Analyte Code
# ??? (Appendix F of HTG) Must add PWSIDNumber, too
duplicates = WQL[WQL.duplicated(subset=['PWSIDNumber', 'Year', 'AggregationType', 'SummaryTimePeriod', 'AnalyteCode'], keep=False)]

# 2. ???? You say earlier to change all uranium to ug/l. Now your gateway checks against pci/l

import pandas as pd

def check_valid_concentration_units(df, valid_units_dict):
    """
    Checks if each row in the Summary Water Quality has a valid ConcentrationUnit
    for its corresponding AnalyteCode.
    Appendix F - How To Guide 2022

    Args:
    df (pandas.DataFrame): The DataFrame to check.
    valid_units_dict (dict): A dictionary that specifies the valid 
    ConcentrationUnit for each AnalyteCode.
    
    Returns:
    pandas.DataFrame: The original DataFrame with an added column called
    'Valid' which contains True if the ConcentrationUnit is valid for the
    corresponding AnalyteCode, otherwise False.
    """
    # Check if each row has a valid ConcentrationUnit for its AnalyteCode
    valid_rows = []
    for i, row in df.iterrows():
        analyte_code = row['AnalyteCode']
        unit = row['ConcentrationUnits']
        if unit in valid_units_dict.get(analyte_code, []):
            valid_rows.append(False)
        else:
            valid_rows.append(True)

    # Add a new column to the DataFrame with the results
    df['inValidUnit'] = valid_rows
    
    return df

Valid_units = check_valid_concentration_units(WQL, valid_units)

# Check if column inValidUnit is totalled to 0
Valid_units.inValidUnit.sum()

#=================
# 4. Quarterly means greater than annual maximums. 
# This error often occurs in submission of purchased water data. 
# Please check your files to make sure the concentrations for 
# purchased water are used in the calculation of the mean and 
# maximum value for that CWS

# No need to check, because we have used the same data for maximum
# and the quarters, as suggested!

# ===================
# 5. We will only accept quarterly data for atrazine (2050), 
# nitrate (1040), HAA5 (2456) and TTHM (2950). 
# Ok. Passed

# ===================
# 6. We request that you only submit mean (“X”) quarterly data

#7. ????? Too high to be a non-detection. New in 2022. What does it mean?

#8. Annual mean and annual maximum data must be included in the WQL file(s).   Every analyte should have both annual
#  mean and annual maximum data submitted in the WQL file

