def calculate_ean13_check_digit(number):
    """
    Calculate the EAN-13 check digit for a 12-digit number.
    """
    if len(number) != 12 or not number.isdigit():
        raise ValueError("Input must be a 12-digit number.")
    
    sum_odd = sum(int(number[i]) for i in range(0, 12, 2))
    sum_even = sum(int(number[i]) for i in range(1, 12, 2))
    total = sum_odd + sum_even * 3
    check_digit = (10 - (total % 10)) % 10
    return str(check_digit)

def generate_ean13_codes(start, count):
    """
    Generate a list of valid EAN-13 codes starting from a given 12-digit number.
    
    Parameters:
    - start: The starting 12-digit number as an integer.
    - count: The number of EAN-13 codes to generate.
    
    Returns:
    - A list of EAN-13 codes as strings.
    """
    ean13_codes = []
    for i in range(count):
        base_number = str(start + i).zfill(12)
        check_digit = calculate_ean13_check_digit(base_number)
        ean13_code = base_number + check_digit
        ean13_codes.append(ean13_code)
    return ean13_codes

# Example usage:
if __name__ == "__main__":
    start_number = 10000000100  # Starting 12-digit number
    total_codes = 400  # Number of EAN-13 codes to generate
    codes = generate_ean13_codes(start_number, total_codes)
    for code in codes:
        print(code)
    # start_number = 100000000060
    # print(generate_ean13_codes(start_number,1))
    