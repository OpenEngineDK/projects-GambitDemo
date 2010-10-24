#include "GambitUI.h"
#include "GambitDemo/ui_GambitUI.h"

#include <Logging/Logger.h>

#define ___VERSION 406000

#include "gambit.h"
void do_eval ___P((char * str),());


using namespace OpenEngine::Display;
using namespace OpenEngine::Utils;

GambitUI::GambitUI(QtEnvironment& env,
                   SimpleSetup& setup) {
    ui = new Ui::GambitUI();
    ui->setupUi(this);

    ui->topLayout->addWidget(env.GetGLWidget());

    show();
}

void GambitUI::enterText() {
    string str = ui->lineEdit->text().toStdString();
    logger.info << str << logger.end;

do_eval((char *)(str.c_str()));

    ui->lineEdit->setText(QString());
}
