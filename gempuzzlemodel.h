#ifndef GEMPUZZLEMODEL_H
#define GEMPUZZLEMODEL_H

#include <QAbstractListModel>
#include <vector>
#include <algorithm>    // std::shuffle
#include <random>       // std::default_random_engine
#include <chrono>       // std::chrono::system_clock

using namespace std;

class GemPuzzleModel : public QAbstractListModel
{
    Q_OBJECT
public:
    GemPuzzleModel (QObject *parent = nullptr,const int dimentionX = 4, const int dimentionY = 4);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    Q_INVOKABLE void resetCells(const int newDimentionX = 4, const int newDimentionY = 4);
    Q_INVOKABLE bool checkCorrectnessPuzzle();
    Q_INVOKABLE bool checkComplete();
    Q_INVOKABLE int swapWithZeroIfPosible(const int value);
    Q_INVOKABLE void move(int from, int to, int count = 1);

private:
    vector<int> cells;
    int dimentionX;
    int dimentionY;
};

#endif // GEMPUZZLEMODEL_H
