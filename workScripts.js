function getShuffledValuesR(cellNumbers) // recursion
{
    // return correct array for 15-pazzle
    let arr = Array.from(Array(cellNumbers).keys()) // create array 0,1,2...cellNumbers
    arr.sort(() => Math.random() - 0.5);  // shuffle values
    let resultArray = checkCorrectnessPuzzle(arr);
    if(resultArray) {
        return resultArray
    } else {
        return getShuffledValues();
    }
}

function getShuffledValues(cellNumbers) // without recursion
{
    // return correct array for 15-pazzle
    let resultArray = false;
    var arr = [];
    while(!resultArray) {
        arr = Array.from(Array(cellNumbers).keys()) // create array 0,1,2...cellNumbers
        arr.sort(() => Math.random() - 0.5);  // shuffle values

        console.log(arr);
        resultArray = checkCorrectnessPuzzle(arr);
    }

    return arr;
}

function checkCorrectnessPuzzle(arr)
{
    let inv = 0;
    let i;
    for ( i=0; i<16; ++i) {
        if (arr[i]) {
            for (let j=0; j<i; ++j) {
                if (arr[j] > arr[i]) {
                    ++inv;
                }
            }
        }
    }
    for (i=0; i<16; ++i) {
        if (arr[i] === 0) {
            inv += 1 + i / 4;
        }
    }

    let solutionExist = !(inv & 1)
    return solutionExist;
}

function checkComplete(arr)
{
    let arrLenght = arr.length;
    if(arr[arrLenght - 1] === 0) {
        for(let i = 0; i < arrLenght - 2; i++) {
            if(arr[i] > arr[i + 1]) {
                return false;
            }
        }
        return true;
    }
    return false;
}

function swapWithZeroIfPosible(arr, value,dementionX = 4, dementionY = 4)
{
    let indexOFValue = arr.indexOf(value);
    let row =  Math.trunc(indexOFValue / dementionY);
    let col = indexOFValue % dementionX;

    // check top element
    if(row > 0 && arr[(((row - 1) * dementionY) + col)] === 0) {
        return swap(arr,indexOFValue,((row - 1) * dementionY + col));
    }

    // check left element
    if(col > 0 && arr[((row * dementionY) + col) - 1] === 0) {
        return swap(arr,indexOFValue,((row * dementionY) + col) - 1);
    }

    // check right element
    if(col < dementionX - 1 && arr[((row * dementionY) + col) + 1] === 0) {
        return swap(arr,indexOFValue,((row * dementionY) + col) + 1);
    }

    // check bottom element
    if(row < dementionY - 1 && arr[((row + 1) * dementionY) + col] === 0) {
        return swap(arr,indexOFValue,((row + 1) * dementionY) + col);
    }
    return false;
}

function swap(arr,index1,index2)
{
    [arr[index1], arr[index2]] = [arr[index2], arr[index1]];
    return [arr, index1 - index2];
}
