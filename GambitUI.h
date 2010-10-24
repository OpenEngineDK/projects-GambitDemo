#ifndef _GAMBIT_UI_H_
#define _GAMBIT_UI_H_

#include <QtGui>
#include <Display/QtEnvironment.h>
#include <Utils/SimpleSetup.h>

namespace Ui { class GambitUI; }

class GambitUI : public QMainWindow {
    Q_OBJECT;
    Ui::GambitUI* ui;
public slots:
    void enterText();
    
public:
    GambitUI(OpenEngine::Display::QtEnvironment& env, 
             OpenEngine::Utils::SimpleSetup& setup);
};

#endif
