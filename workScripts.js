function getShuffledValues(dimentionX, dimentionY)
{
    // return correct array for 15-puzzle
    let resultArray = false;
    var arr = [];
    while (!resultArray) {
        arr = Array.from(Array(dimentionX * dimentionY).keys()); // create array 0,1,2...cellNumbers
        arr.sort(() => Math.random() - 0.5);  // shuffle values

        console.log(arr);
        resultArray = checkCorrectnessPuzzle(arr, dimentionY);
    }

    return arr;
}

function checkCorrectnessPuzzle(arr, dimentionY)
{
    let inv = 0;
    let arrayLenght = arr.length;
    let i;
    for (i = 0; i < arrayLenght; ++i) {
        if (arr[i]) {
            for (let j = 0; j < i; ++j) {
                if (arr[j] > arr[i]) {
                    ++inv;
                }
            }
        }
    }
    for (i = 0; i < arrayLenght; ++i) {
        if (arr[i] === 0) {
            inv += 1 + i / dimentionY;
        }
    }

    let solutionExist = !(inv % 2);
    return solutionExist;
}

function checkComplete(arr)
{
    let arrLenght = arr.length;
    if (arr[arrLenght - 1] === 0) {
        for (let i = 0; i < arrLenght - 2; i++) {
            if (arr[i] > arr[i + 1]) {
                return false;
            }
        }
        return true;
    }
    return false;
}

function swapWithZeroIfPosible(arr, value, dimentionX = 4, dimentionY = 4)
{
    let indexOFValue = arr.indexOf(value);
    let row =  Math.trunc(indexOFValue / dimentionY);
    let col = indexOFValue % dimentionX;

    // check top element
    if (row > 0 && arr[((row - 1) * dimentionY) + col] === 0) {
        return swap(arr,indexOFValue,((row - 1) * dimentionY) + col);
    }

    // check left element
    if (col > 0 && arr[((row * dimentionY) + col) - 1] === 0) {
        return swap(arr,indexOFValue,((row * dimentionY) + col) - 1);
    }

    // check right element
    if (col < dimentionX - 1 && arr[((row * dimentionY) + col) + 1] === 0) {
        return swap(arr,indexOFValue,((row * dimentionY) + col) + 1);
    }

    // check bottom element
    if (row < dimentionY - 1 && arr[((row + 1) * dimentionY) + col] === 0) {
        return swap(arr,indexOFValue,((row + 1) * dimentionY) + col);
    }
    return false;
}

function swap(arr, index1, index2)
{
    [arr[index1], arr[index2]] = [arr[index2], arr[index1]];
    return [arr, index1 - index2];
}
