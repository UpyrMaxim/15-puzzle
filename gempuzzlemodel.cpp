#include "gempuzzlemodel.h"
#include <QDebug>
#include <iostream>

GemPuzzleModel::GemPuzzleModel(QObject *parent, const int dimentionX, const int dimentionY)
    : QAbstractListModel(parent), dimentionX(dimentionX), dimentionY(dimentionY)
{
    int cellsCount = dimentionX * dimentionY;
    cells.reserve(cellsCount);

    for (int i = 0; i < cellsCount; ++i) {
        cells.push_back(i);
    }
}

int GemPuzzleModel::rowCount(const QModelIndex &) const
{
    return cells.size();
}

QVariant GemPuzzleModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() >= static_cast<int>(cells.size()))
        return QVariant();

    if (role == Qt::DisplayRole)
        return cells.at(index.row());
    else
        return QVariant();
}

Qt::ItemFlags GemPuzzleModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::ItemIsEnabled;

    return QAbstractItemModel::flags(index) | Qt::ItemIsEditable;
}

void GemPuzzleModel::resetCells(const int newDimentionX, const int newDimentionY)
{
    int cellsCount = newDimentionX * newDimentionY;
    beginResetModel();
    if (newDimentionX != dimentionX || newDimentionY != dimentionY) {
        dimentionX = newDimentionX;
        dimentionY = newDimentionY;

        cells.clear();
        cells.reserve(cellsCount);

        for (int i = 0; i < cellsCount; ++i) {
            cells.push_back(i);
        }
    }
    bool correctCells = false; // check if puzzle correct

    while (!correctCells) {
        unsigned seed = chrono::system_clock::now().time_since_epoch().count();
        shuffle (cells.begin(), cells.end(), default_random_engine(seed));
        correctCells = checkCorrectnessPuzzle();
    }

    endResetModel();
}

bool GemPuzzleModel::checkCorrectnessPuzzle()
{
    int inv = 0;
    int arrayLenght = cells.size();
    for (int i = 0; i < arrayLenght; ++i) {
        if (cells[i]) {
            for (int j = 0; j < i; ++j) {
                if (cells[j] > cells[i]) {
                    ++inv;
                }
            }
        }
    }
    for (int i = 0; i < arrayLenght; ++i) {
        if (cells[i] == 0) {
            inv += 1 + i / dimentionY;
        }
    }

    bool solutionExist = !(inv % 2);
    return solutionExist;
}

bool GemPuzzleModel::checkComplete()
{
    int arrLenght = cells.size();
    if (cells[arrLenght - 1] == 0) {
        for (int i = 0; i < arrLenght - 2; i++) {
            if (cells[i] > cells[i + 1]) {
                return false;
            }
        }
        return true;
    }
    return false;
}

int GemPuzzleModel::swapWithZeroIfPosible(const int value)
{
    auto it = find(cells.begin(), cells.end(), value);

    if (it == cells.end()) {
        return false;
    }

    int indexOFValue = distance(cells.begin(), it);
    int row =  indexOFValue / dimentionY;
    int col = indexOFValue % dimentionX;
    int newIndex = -1;
    int shift = 0;

    // check top element
    if (row > 0 && cells[((row - 1) * dimentionY) + col] == 0) {
        newIndex = ((row - 1) * dimentionY) + col;
    }

    // check left element
    if (col > 0 && cells[((row * dimentionY) + col) - 1] == 0) {
        newIndex = ((row * dimentionY) + col) - 1;
    }

    // check right element
    if (col < dimentionX - 1 && cells[((row * dimentionY) + col) + 1] == 0) {
        newIndex = ((row * dimentionY) + col) + 1;
        shift = 1;
    }

    // check bottom element
    if (row < dimentionY - 1 && cells[((row + 1) * dimentionY) + col] == 0) {
        newIndex = ((row + 1) * dimentionY) + col;
        shift = 1;
    }

    if (newIndex > -1) {
//        swap(cells[indexOFValue], cells[newIndex]);
//        auto index = createIndex(indexOFValue, 0, nullptr);
//        emit dataChanged(index, index, { Qt::DisplayRole });
//        index = createIndex(newIndex, 0, nullptr);
//        emit dataChanged(index, index, { Qt::DisplayRole });
//        qDebug() << "from: " << indexOFValue << " to: " << newIndex;

        for(const auto &tmp: cells)
            cout << tmp<< " ";
        cout << endl;
        qDebug() << "from: " << indexOFValue << " to: " << newIndex;


        beginMoveRows(QModelIndex(), indexOFValue, indexOFValue, QModelIndex(), newIndex + shift);
        endMoveRows();

        if(abs(indexOFValue - newIndex) > 1) {
            int zeroPositionShift = newIndex > indexOFValue ? -1 : 1;
            cout << "shift: " << shift << endl;
            beginMoveRows(QModelIndex(), newIndex + zeroPositionShift, newIndex + zeroPositionShift,QModelIndex(), indexOFValue + shift + zeroPositionShift);
            endMoveRows();
        }

        swap(cells[indexOFValue], cells[newIndex]);
//        auto index = createIndex(indexOFValue, 0, nullptr);
//        emit dataChanged(index, index, { Qt::DisplayRole });
//        index = createIndex(newIndex, 0, nullptr);
//        emit dataChanged(index, index, { Qt::DisplayRole });
        for(const auto &tmp: cells)
            cout << tmp << " ";
        cout << endl;
        return indexOFValue - newIndex;
    }

    return false;
}

void GemPuzzleModel::move(int from, int to, int )
{
    qDebug() << "from: " << from << " to: " << to;
}



