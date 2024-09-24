


# FUNCTION: Calculates compound interest
def compound_interest(principal, rate, time):
    Amount = principal * (pow((1 + rate / 100), time))
    CI = Amount - principal
    print("Compound interest is", CI)
    print("Total amount is $", Amount)


# CLASS: Book
class Book:  
    def __init__(self, title, author, genre, page_count):
        self.title = title
        self.author = author
        self.genre = genre
        self.page_count = page_count
