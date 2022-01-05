//
//  WaveSinView.swift
//  trafficStat
//
//  Created by Dolor•Sawalon•Zerlz on 2021/9/15.
//

/*
 基础知识：
 y=A*sin(wt±φ)
 A 為波幅/振幅（縱軸）， ω 為角频率， t 為時間（橫軸）， θ 為相偏移（橫軸左右）
 A振幅，离开平衡位置的距离
 以下为左边原点在左下角
 w变大横坐标压缩，w变小横坐标拉伸(相对于sin(x))
 θ为Pi * 1/3,则坐标不变横坐标向左边偏移Pi * 1/3(相对于sin(x))
 θ为-Pi * 1/3,则坐标不变横坐标向右边偏移Pi * 1/3(相对于sin(x))
 A变大则横坐标不变，则纵坐标变为A倍，
 比如A=2,则纵坐标为原来的2倍，A=1/2，则纵坐标为原来的1/2倍
 A=-1，则曲线根据X轴进行了翻转
 A=-2，则在-1的基础上进行拉伸
 
 https://www.bilibili.com/video/BV1a7411s75L/?spm_id_from=333.788.recommend_more_video.-1
 
 
 https://zh.wikipedia.org/wiki/正弦曲線
 y=A*sin(kx-wt - φ) + D
 k 為波數（周期密度）， D 為（直流）偏移量（y軸高低
 
 https://zh.wikipedia.org/wiki/抛物线
 让波浪不规则
 */
import SwiftUI

public struct SineWaveShape: Shape {
    
    public var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }
    //波浪的高度相对于rect.height的百分比
    var percent: Double
    
    //波浪振幅
    var strength: Double
    
    // 频率
    var frequency: Double
    
    // 波浪的相位
    var phase: Double
    
    public init(
        percent: Double,
        strength: Double,
        frequency: Double,
        phase: Double
    
    ) {
        self.percent = percent
        self.strength = strength
        self.frequency = frequency
        self.phase = phase
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let oneOverMidWidth = 1 / midWidth
        
        //根据 波的相速度 / 频率 = 波长
        let wavelength = width / frequency
        
        //从左边的终点开始画
        path.move(to: CGPoint(x: 0, y: height))
        
        // 根据x轴,计算每个横向点对应的y位置
        for x in stride(from: 0, through: width, by: 1) {
            //找到当前x相对于波长的位置
            let relativeX = x / wavelength
            
            //当前x距离中心位置多远
            let distanceFromMidWidth = x - midWidth
            
            // 波浪规则变化系数， 从-1 到 1的变化（让曲线不是一成不变的
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            
            let parabola = -(normalDistance * normalDistance) + 1
            
            //计算那个位置的正弦，加上我们的相位偏移
            let sine = sin(relativeX + phase)
            
            //将计算出来的正弦乘以我们的波浪振幅然后再乘以规则变化系数以确定最终偏移量，然后将其向下移动到midHeight
            let y = parabola * strength * sine + height * percent
            
            // 画线
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}
